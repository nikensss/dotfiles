local is_deno_project = require('ricard.functions').is_deno_project

local lint = require('lint')

lint.linters_by_ft = {
	javascript = { 'eslint' },
	typescript = { 'eslint' },
	javascriptreact = { 'eslint' },
	typescriptreact = { 'eslint' },
	svelte = { 'eslint' },
	python = { 'pylint' },
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
	group = lint_augroup,
	callback = function()
		if is_deno_project() then
			lint.linters_by_ft = {
				javascript = { 'deno' },
				typescript = { 'deno' },
				javascriptreact = { 'deno' },
				typescriptreact = { 'deno' },
				svelte = { 'deno' },
				python = { 'pylint' },
			}
		end

		lint.try_lint()
	end,
})
