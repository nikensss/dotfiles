local conform = require('conform')

conform.setup({
	formatters_by_ft = {
		css = { { 'prettier' } },
		graphql = { { 'prettier' } },
		html = { { 'prettier' } },
		javascript = { { 'prettier' } },
		javascriptreact = { { 'prettier' } },
		json = { { 'prettier' } },
		lua = { 'stylua' },
		markdown = { { 'prettier' } },
		python = { 'isort', 'black' },
		sql = { 'sleek' },
		typescript = { { 'prettier' } },
		typescriptreact = { { 'prettier' } },
		yaml = { { 'prettier' } },
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
	},
})

vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 3000,
	})
end, { desc = 'Format file or range (in visual mode)' })
