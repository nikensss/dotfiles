local is_deno_project = require('ricard.functions').is_deno_project
local conform = require('conform')

local function formatters_checked_with_deno()
	if is_deno_project() then
		return { 'deno_fmt' }
	else
		return { 'prettierd', 'prettier' }
	end
end

conform.setup({
	formatters_by_ft = {
		cpp = { 'clang-format' },
		css = { 'prettierd', 'prettier' },
		gleam = { 'gleam' },
		go = { 'goimports' },
		gomod = { 'goimports' },
		graphql = { 'prettierd', 'prettier' },
		html = { 'prettierd', 'prettier' },
		javascript = formatters_checked_with_deno,
		javascriptreact = formatters_checked_with_deno,
		json = formatters_checked_with_deno,
		jsonc = formatters_checked_with_deno,
		lua = { 'stylua' },
		markdown = formatters_checked_with_deno,
		python = { 'isort', 'black' },
		sql = { 'sleek' },
		swift = { 'swiftformat' },
		typescript = formatters_checked_with_deno,
		typescriptreact = formatters_checked_with_deno,
		yaml = { 'prettierd', 'prettier' },
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
