local conform = require('conform')

conform.setup({
	formatters_by_ft = {
		cpp = { 'clang-format' },
		css = { { 'prettierd', 'prettier' } },
		gleam = { 'gleam' },
		go = { 'goimports' },
		gomod = { 'goimports' },
		graphql = { { 'prettierd', 'prettier' } },
		html = { { 'prettierd', 'prettier' } },
		javascript = { 'prettierd', 'prettier' },
		javascriptreact = { 'prettierd', 'prettier' },
		json = { 'prettierd', 'prettier' },
		jsonc = { 'prettierd', 'prettier' },
		lua = { 'stylua' },
		markdown = { 'prettierd', 'prettier' },
		prisma = { 'prismals' },
		python = { 'isort', 'black' },
		sql = { 'sleek' },
		typescript = { 'prettierd', 'prettier' },
		typescriptreact = { 'prettierd', 'prettier' },
		yaml = { { 'prettierd', 'prettier' } },
	},
	format_on_save = {
		lsp_fallback = true,
		async = false,
		timeout_ms = 3000,
	},
	formatters = {
		sleek = {
			command = 'sleek',
		},
		gleam = {
			command = 'gleam',
			args = { 'format', '--stdin' },
		},
	},
})

vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 3000,
	})
end, { desc = 'Format file or range (in visual mode)' })
