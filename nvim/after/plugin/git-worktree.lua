require('git-worktree').setup()

vim.keymap.set('n', '<leader>gw', function()
	require('telescope').extensions.git_worktree.git_worktrees()
end, { noremap = true, silent = true, desc = '[git-worktree] show worktrees' })

vim.keymap.set('n', '<leader>gc', function()
	require('telescope').extensions.git_worktree.create_git_worktree()
end, { noremap = true, silent = true, desc = '[git-worktree] create worktree' })
