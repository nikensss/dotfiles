require('hop').setup()

vim.keymap.set('n', 's', vim.cmd.HopWord)
vim.keymap.set('n', 'S', vim.cmd.HopWordMW)
vim.keymap.set('n', '<leader>s', vim.cmd.HopChar1)
vim.keymap.set('n', '<leader>S', vim.cmd.HopChar1MW)
