return function()
	local lsp_helpers = require('ricard.lsp_helpers')
	local on_attach = lsp_helpers.on_attach
	local capabilities = lsp_helpers.capabilities()

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
		'html',
		'jdtls',
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
		vim.lsp.config(server, {
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end

	-- configure graphql language server
	vim.lsp.config('graphql', {
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { 'graphql', 'gql', 'svelte', 'typescriptreact', 'javascriptreact' },
	})

	-- configure sql language server
	vim.lsp.config('sqlls', {
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { 'sql' },
	})

	-- configure clangd server
	vim.lsp.config('clangd', {
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

	-- configure gleam server
	vim.lsp.config('gleam', {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { 'gleam', 'lsp' },
	})

	-- configure lua server (with special settings)
	vim.lsp.config('lua_ls', {
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
end
