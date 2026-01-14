local is_deno_project = require('ricard.functions').is_deno_project

local lint = require('lint')

-- Configure eslint to prefer local node_modules, fallback to eslint_d from Mason
-- Using a function so it's evaluated per-buffer (handles switching between projects)
lint.linters.eslint = vim.tbl_deep_extend('force', lint.linters.eslint or {}, {
	cmd = function()
		-- First, try local node_modules eslint (relative to current buffer's directory)
		local local_eslint = vim.fn.fnamemodify('node_modules/.bin/eslint', ':p')
		if vim.fn.executable(local_eslint) == 1 then
			return local_eslint
		end

		-- Try from project root
		local root_eslint = vim.fn.findfile('node_modules/.bin/eslint', '.;')
		if root_eslint ~= '' and vim.fn.executable(root_eslint) == 1 then
			return vim.fn.fnamemodify(root_eslint, ':p')
		end

		-- Fallback to eslint_d (installed via Mason)
		return 'eslint_d'
	end,
})

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
