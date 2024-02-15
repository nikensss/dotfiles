local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
	opts.buffer = bufnr

	require('lsp-inlayhints').on_attach(client, bufnr)
	require('lsp-inlayhints').show()

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
	keymap.set('n', 'gj', '<cmd>Telescope lsp_incoming_calls<CR>', opts) -- show outline

	opts.desc = 'Show outgoing calls'
	keymap.set('n', 'gk', '<cmd>Telescope lsp_outgoing_calls<CR>', opts) -- show outline

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
	keymap.set('n', '[d', vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

	opts.desc = 'Go to next diagnostic'
	keymap.set('n', ']d', vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

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

-- configure html server
lspconfig['html'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure css server
lspconfig['cssls'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure prisma orm server
lspconfig['prismals'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tailwind css server
lspconfig['tailwindcss'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

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

-- configure python server
lspconfig['pyright'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
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
					[vim.fn.expand('$VIMRUNTIME/lua')] = true,
					[vim.fn.stdpath('config') .. '/lua'] = true,
				},
			},
		},
	},
})

-- typescript-tools
require('typescript-tools').setup({
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)

		local options = { desc = '[ts-tools] organize imports' }
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
			includeInlayParameterNameHints = 'all',
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayVariableTypeHintsWhenTypeMatchesName = false,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
	},
})

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

-- rustacean.nvim

HOME_PATH = os.getenv('HOME') .. '/'
MASON_PATH = HOME_PATH .. '.local/share/nvim/mason/packages/'
local codelldb_path = MASON_PATH .. 'codelldb/extension/adapter/codelldb'
local liblldb_path = MASON_PATH .. 'codelldb/extension/lldb/lib/liblldb.dylib'

vim.g.rustaceanvim = function()
	local cfg = require('rustaceanvim.config')
	return {
		tools = {
			hover_actions = {
				auto_focus = true,
			},
		},
		server = {
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)

				vim.keymap.set('n', '<leader>rb', function()
					vim.cmd.RustLsp('debuggables')
				end, { desc = '[rustaceanvim] rust debuggables' })

				vim.keymap.set('n', '<leader>rl', function()
					vim.cmd.RustLsp({ 'debuggables', bang = true })
				end, { desc = '[rustaceanvim] rust test nearest' })

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
		-- DAP configuration
		dap = {
			adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
		},
	}
end
