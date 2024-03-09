vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
vim.keymap.set('n', '<leader>gb', function()
	vim.cmd.Git('blame')
end)
vim.keymap.set('n', '<leader>gp', function()
	vim.cmd.Git('push')
end)

vim.keymap.set('n', '<leader><leader>gl', [[ :diffget //3<CR> ]])
vim.keymap.set('n', '<leader><leader>gh', [[ :diffget //2<CR> ]])

vim.keymap.set('n', '<leader>gl', [[ :0Gclog<CR> ]])
vim.keymap.set('v', '<leader>gl', [[ :Gclog<CR> ]])

vim.keymap.set('n', '<leader>gd', [[ :DiffviewOpen<CR> ]])
vim.keymap.set('n', '<leader><leader>gd', [[ :DiffviewOpen ]])
