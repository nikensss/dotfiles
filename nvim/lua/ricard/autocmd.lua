vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'gitcommit', 'markdown', 'txt' },
	group = vim.api.nvim_create_augroup('prose_writting', { clear = true }),
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.textwidth = 79
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'zsh', 'sh' },
	group = vim.api.nvim_create_augroup('set_ft_to_bash', { clear = true }),
	callback = function()
		vim.opt_local.ft = 'bash'
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'dbout' },
	group = vim.api.nvim_create_augroup('dbout_filetype_settings', { clear = true }),
	callback = function()
		vim.opt.colorcolumn = '0'
	end,
})

local function db_completion()
	require('cmp').setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
end

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'sql' },
	group = vim.api.nvim_create_augroup('sql-dadbod-autocompletion', { clear = true }),
	command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'sql', 'mysql', 'plsql' },
	group = vim.api.nvim_create_augroup('sql-dadbod-autocompletion-1', { clear = true }),
	callback = function()
		vim.schedule(db_completion)
	end,
})
