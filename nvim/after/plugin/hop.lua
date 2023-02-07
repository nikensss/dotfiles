require 'hop'.setup()

vim.keymap.set('n', '<leader>hw', vim.cmd.HopWord)
vim.keymap.set('n', '<leader>hm', vim.cmd.HopWordMW)
vim.keymap.set('n', '<leader>hc', vim.cmd.HopChar1)
vim.keymap.set('n', '<leader>hx', vim.cmd.HopChar1MW)
