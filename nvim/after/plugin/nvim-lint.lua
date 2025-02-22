local is_deno_project = require('ricard.functions').is_deno_project

local lint = require('lint')

lint.linters_by_ft = {
	javascript = { 'eslint' },
	javascriptreact = { 'eslint' },
	python = { 'pylint' },
	svelte = { 'eslint' },
	swift = { 'swiftlint' },
	typescript = { 'eslint' },
	typescriptreact = { 'eslint' },
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
	group = lint_augroup,
	callback = function()
		if is_deno_project() then
			lint.linters_by_ft.javascript = { 'deno' }
			lint.linters_by_ft.typescript = { 'deno' }
			lint.linters_by_ft.javascriptreact = { 'deno' }
			lint.linters_by_ft.typescriptreact = { 'deno' }
			lint.linters_by_ft.svelte = { 'deno' }
			lint.try_lint()
			return
		else
			lint.linters_by_ft.javascript = { 'eslint' }
			lint.linters_by_ft.typescript = { 'eslint' }
			lint.linters_by_ft.javascriptreact = { 'eslint' }
			lint.linters_by_ft.typescriptreact = { 'eslint' }
			lint.linters_by_ft.svelte = { 'eslint' }
		end

		lint.try_lint()
	end,
})
