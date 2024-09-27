vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'git status' })
vim.keymap.set('n', '<leader>gb', function()
	vim.cmd.Git('blame')
end, { desc = 'git blame' })
vim.keymap.set('n', '<leader>gp', function()
	vim.cmd.Git('push')
end, { desc = 'git push' })

vim.keymap.set('n', '<leader><leader>gl', [[ :diffget //3<CR> ]], { desc = '[git] keep theirs' })
vim.keymap.set('n', '<leader><leader>gh', [[ :diffget //2<CR> ]], { desc = '[git] keep ours' })

vim.keymap.set('n', '<leader>gl', [[ :0Gclog<CR> ]])
vim.keymap.set('v', '<leader>gl', [[ :Gclog<CR> ]])

vim.keymap.set('n', '<leader>gd', [[ :DiffviewOpen<CR> ]])
vim.keymap.set('n', '<leader><leader>gd', [[ :DiffviewOpen ]])
