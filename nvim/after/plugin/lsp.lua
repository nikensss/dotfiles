local is_deno_project = require('ricard.functions').is_deno_project

local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local navbuddy = require('nvim-navbuddy')
local navic = require('nvim-navic')

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
	opts.buffer = bufnr

	if client.server_capabilities.documentSymbolProvider then
		navbuddy.attach(client, bufnr)
		if not navic.is_available(bufnr) then
			navic.attach(client, bufnr)
		end
	end

	-- set keybinds
	opts.desc = 'Show LSP references'
	keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts) -- show definition, references

	opts.desc = 'Go to declaration'
	keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- go to declaration

	opts.desc = 'Show LSP definitions'
	keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts) -- show lsp definitions
	keymap.set('n', '<C-g><C-d>', '<C-w><C-v><cmd>Telescope lsp_definitions<CR>', opts) -- show lsp definitions

	opts.desc = 'Show LSP type definitions'
	keymap.set('n', 'gy', '<cmd>Telescope lsp_type_definitions<CR>', opts) -- show lsp type definitions

	opts.desc = 'Show LSP implementations'
	keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts) -- show lsp implementations

	opts.desc = 'Show incoming calls'
	keymap.set('n', 'gj', '<cmd>Telescope lsp_incoming_calls<CR>', opts) -- show incoming calls

	opts.desc = 'Show outgoing calls'
	keymap.set('n', 'gk', '<cmd>Telescope lsp_outgoing_calls<CR>', opts) -- show outgoing calls

	-- opts.desc = 'See available code actions'
	-- keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

	opts.desc = 'Smart rename'
	keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- smart rename

	opts.desc = 'Show buffer diagnostics'
	keymap.set('n', '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<CR>', opts) -- show  diagnostics for file

	opts.desc = 'Show workspace diagnostics ([s]how [e]rrors)'
	keymap.set('n', '<leader>se', '<cmd>Telescope diagnostics <CR>', opts) -- show  diagnostics for file

	opts.desc = 'Show line diagnostics'
	keymap.set('n', '<leader>ld', vim.diagnostic.open_float, opts) -- show diagnostics for line

	opts.desc = 'Go to previous diagnostic'
	keymap.set('n', '[e', vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

	opts.desc = 'Go to next diagnostic'
	keymap.set('n', ']e', vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

	opts.desc = 'Show documentation for what is under cursor'
	keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

	opts.desc = 'Signature help'
	keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts) -- show documentation for what is under cursor

	opts.desc = 'Restart LSP'
	keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts) -- mapping to restart lsp if necessary
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
for type, icon in pairs(signs) do
	local hl = 'DiagnosticSign' .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

-- create an array of server to configure
local servers = {
	'bashls',
	'cssls',
	'emmet_language_server',
	'eslint',
	'html',
	'jsonls',
	'prismals',
	'pyright',
	'sourcekit',
	'tailwindcss',
	'taplo',
	'zls',
}

-- loop over the array and call setup for each server
for _, server in ipairs(servers) do
	if lspconfig[server] then
		lspconfig[server].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	else
		print('LSP server ' .. server .. ' is not available in lspconfig')
	end
end

-- configure graphql language server
lspconfig['graphql'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { 'graphql', 'gql', 'svelte', 'typescriptreact', 'javascriptreact' },
})

-- configure sql language server
lspconfig['sqlls'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { 'sql' },
})

-- configure clangd server
lspconfig['clangd'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = {
		'clangd',
		'--background-index',
		'--suggest-missing-includes',
		'--clang-tidy',
		'--header-insertion=iwyu',
	},
})

-- configure go server
lspconfig['gopls'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		gopls = {
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})

-- configure gleam server
lspconfig['gleam'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { 'gleam', 'lsp' },
})

-- configure lua server (with special settings)
lspconfig['lua_ls'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					vim.fn.expand('$VIMRUNTIME/lua'),
					vim.fn.expand('$XDG_CONFIG_HOME') .. '/nvim/lua',
				},
			},
		},
	},
})

-- typescript-tools
if is_deno_project() then
	require('deno-nvim').setup({
		server = {
			on_attach = on_attach,
			capabilites = capabilities,
			settings = {
				deno = {
					inlayHints = {
						parameterNames = {
							enabled = 'all',
						},
						parameterTypes = {
							enabled = true,
						},
						variableTypes = {
							enabled = true,
						},
						propertyDeclarationTypes = {
							enabled = true,
						},
						functionLikeReturnTypes = {
							enabled = true,
						},
						enumMemberValues = {
							enabled = true,
						},
					},
				},
			},
		},
	})
else
	require('typescript-tools').setup({
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)

			local options = { desc = '[ts-tools] organize imports', buffer = bufnr }
			vim.keymap.set('n', '<leader>tso', vim.cmd.TSToolsOrganizeImports, options)

			options = { desc = '[ts-tools] sort imports' }
			vim.keymap.set('n', '<leader>tsi', vim.cmd.TSToolsSortImports, options)

			options = { desc = '[ts-tools] remove unused statements' }
			vim.keymap.set('n', '<leader>tss', vim.cmd.TSToolsRemoveUnused, options)

			options = { desc = '[ts-tools] remove unused imports' }
			vim.keymap.set('n', '<leader>tsu', vim.cmd.TSToolsRemoveUnusedImports, options)

			options = { desc = '[ts-tools] add missing imports' }
			vim.keymap.set('n', '<leader>tsa', vim.cmd.TSToolsAddMissingImports, options)

			options = { desc = '[ts-tools] re-attach lsp' }
			vim.keymap.set('n', '<leader>tsk', function()
				on_attach(client, vim.api.nvim_get_current_buf())
			end, options)
		end,
		settings = {
			tsserver_file_preferences = {
				importModuleSpecifierPreference = 'non-relative',
				-- includeInlayParameterNameHints = 'all',
				-- includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				-- includeInlayFunctionParameterTypeHints = true,
				-- includeInlayVariableTypeHints = true,
				-- includeInlayVariableTypeHintsWhenTypeMatchesName = false,
				-- includeInlayPropertyDeclarationTypeHints = true,
				-- includeInlayFunctionLikeReturnTypeHints = true,
				-- includeInlayEnumMemberValueHints = true,
			},
		},
	})
end

local format_diagnostic_message = function(diagnostic)
	local severity = vim.diagnostic.severity[diagnostic.severity]
	local message = ''
	if severity ~= nil then
		message = string.format('[%s]', severity)
	end

	if diagnostic.message ~= nil then
		message = string.format('%s %s', message, diagnostic.message)
	end

	if diagnostic.source ~= nil then
		message = string.format('%s (%s)', message, diagnostic.source)
	end

	return message
end

vim.diagnostic.config({
	float = {
		focusable = false,
		style = 'minimal',
		border = 'rounded',
		source = false,
		header = '',
		prefix = '',
		format = format_diagnostic_message,
	},
	virtual_text = {
		spacing = 2,
		format = format_diagnostic_message,
	},
})

vim.g.rustaceanvim = function()
	return {
		tools = {
			hover_actions = {
				auto_focus = true,
			},
		},
		server = {
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)

				vim.keymap.set('n', '<leader>rt', function()
					vim.cmd.RustLsp('testables')
				end, { desc = '[rustaceanvim] rust testables' })

				vim.keymap.set('n', '<leader>rr', function()
					vim.cmd.RustLsp({ 'testables', bang = true })
				end, { desc = '[rustaceanvim] rust testables' })

				vim.keymap.set('n', '<leader>rb', function()
					vim.cmd.RustLsp('debuggables')
				end, { desc = '[rustaceanvim] rust debuggables' })

				vim.keymap.set('n', '<leader>rl', function()
					vim.cmd.RustLsp({ 'debuggables', bang = true })
				end, { desc = '[rustaceanvim] rust debug last' })

				vim.keymap.set('n', '<leader>ra', function()
					vim.cmd.RustLsp('codeAction')
				end, { silent = true, desc = '[rustaceanvim] code actions' })

				vim.keymap.set('n', '<leader>rh', function()
					vim.cmd.RustLsp({ 'hover', 'actions' })
				end, { silent = true, desc = '[rustaceanvim] hover actions' })

				vim.keymap.set('n', '<leader>re', function()
					vim.cmd.RustLsp('explainError')
				end, { silent = true, desc = '[rustaceanvim] render diagnostics' })

				vim.keymap.set('n', '<leader>rd', function()
					vim.cmd.RustLsp('renderDiagnostic')
				end, { silent = true, desc = '[rustaceanvim] render diagnostics' })
			end,
		},
	}
end

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'sh',
	callback = function()
		vim.lsp.start({
			name = 'bash-language-server',
			cmd = { 'bash-language-server', 'start' },
		})
	end,
})
