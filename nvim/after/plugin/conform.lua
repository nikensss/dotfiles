local conform = require('conform')
local default_prettier_cwd = require('conform.formatters.prettierd').cwd

local function package_cwd(self, ctx)
	return vim.fs.root(ctx.dirname, { 'package.json' }) or default_prettier_cwd(self, ctx)
end

local prettier = { 'prettierd', 'prettier', stop_after_first = true }
local biome_or_prettier = { 'biome', 'prettierd', 'prettier', stop_after_first = true }

conform.setup({
	formatters_by_ft = {
		cpp = { 'clang-format' },
		css = biome_or_prettier,
		gleam = { 'gleam' },
		graphql = prettier,
		html = prettier,
		javascript = biome_or_prettier,
		javascriptreact = biome_or_prettier,
		json = biome_or_prettier,
		jsonc = biome_or_prettier,
		lua = { 'stylua' },
		markdown = prettier,
		sql = { 'sleek' },
		typescript = biome_or_prettier,
		typescriptreact = biome_or_prettier,
		yaml = prettier,
	},
	formatters = {
		biome = {
			condition = function(self, ctx)
				return vim.fs.find(
					{ 'biome.json', 'biome.jsonc' },
					{ path = ctx.filename, upward = true }
				)[1] ~= nil
			end,
		},
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
