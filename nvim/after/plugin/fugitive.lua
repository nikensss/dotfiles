vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
vim.keymap.set('n', '<leader>gb', function() vim.cmd.Git('blame') end)
vim.keymap.set('n', '<leader>gp', function() vim.cmd.Git('push') end)
