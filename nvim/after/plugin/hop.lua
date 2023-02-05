require 'hop'.setup()

vim.keymap.set('n', '<leader>hw', vim.cmd.HopWordAC)
vim.keymap.set('n', '<leader>hb', vim.cmd.HopWordBC)
vim.keymap.set('n', '<leader>hm', vim.cmd.HopWordMW)
vim.keymap.set('n', '<leader>hc', vim.cmd.HopChar1)
vim.keymap.set('n', '<leader>hs', vim.cmd.HopChar1MW)
