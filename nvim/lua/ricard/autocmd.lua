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

-- vim.api.nvim_create_autocmd('VimLeave', {
-- 	group = vim.api.nvim_create_augroup('save_session', { clear = true }),
-- 	callback = function()
-- 		local target = vim.fn.expand('~/.config/nvim/' .. get_current_folder_name() .. '.session')
-- 		vim.cmd('mksession! ' .. target)
-- 		print('session saved to ' .. target)
-- 	end,
-- })

-- vim.api.nvim_create_autocmd('VimEnter', {
-- 	group = vim.api.nvim_create_augroup('restore_session', { clear = true }),
-- 	callback = function()
-- 		local target = vim.fn.expand('~/.config/nvim/' .. get_current_folder_name() .. '.session')
-- 		if vim.fn.filereadable(target) == 1 then
-- 			print('loading session from ' .. target)
-- 			vim.defer_fn(function()
-- 				vim.cmd('source ' .. target)
-- 				print('session loaded from ' .. target)
-- 			end, 1000)
-- 		else
-- 			print('no session found')
-- 		end
-- 	end,
-- })

-- Use an augroup to clear previous autocmds of the same group and avoid duplicates
vim.api.nvim_create_augroup('UnfoldDboutFiles', { clear = true })

-- Create the autocmd
vim.api.nvim_create_autocmd('FileType', {
	-- Specify the filetype
	pattern = 'dbout',
	-- Specify the command to run: 'set foldlevel=99' opens all folds
	callback = function()
		vim.cmd('normal! zR')
	end,
	-- Specify the group to use, so this autocmd is managed under 'UnfoldDboutFiles'
	group = 'UnfoldDboutFiles',
})

vim.api.nvim_create_autocmd('VimEnter', {
	group = vim.api.nvim_create_augroup('telescope_fzf_on_start', { clear = true }),
	callback = function()
		local function starts_with(str, start)
			return str:sub(1, #start) == start
		end

		if starts_with(vim.bo.filetype, 'git') then
			return
		end

		require('telescope.builtin').git_files()
	end,
})
