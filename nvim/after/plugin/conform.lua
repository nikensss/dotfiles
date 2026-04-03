local conform = require('conform')
local default_prettier_cwd = require('conform.formatters.prettierd').cwd

local function package_cwd(self, ctx)
	return vim.fs.root(ctx.dirname, { 'package.json' }) or default_prettier_cwd(self, ctx)
end

local prettier = { 'prettierd', 'prettier' }

conform.setup({
	formatters_by_ft = {
		cpp = { 'clang-format' },
		css = prettier,
		gleam = { 'gleam' },
		graphql = prettier,
		html = prettier,
		javascript = prettier,
		javascriptreact = prettier,
		json = prettier,
		jsonc = prettier,
		lua = { 'stylua' },
		markdown = prettier,
		sql = { 'sleek' },
		typescript = prettier,
		typescriptreact = prettier,
		yaml = prettier,
	},
	formatters = {
		prettier = {
			cwd = package_cwd,
		},
		prettierd = {
			cwd = package_cwd,
		},
		sleek = {
			command = 'sleek',
		},
		gleam = {
			command = 'gleam',
			args = { 'format', '--stdin' },
		},
	},
})

vim.keymap.set('n', '<leader>w', function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 3000,
	}, function()
		vim.cmd.write()
	end)
end, { desc = 'Format file' })

vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 3000,
	})
end, { desc = 'Format file or range (in visual mode)' })
