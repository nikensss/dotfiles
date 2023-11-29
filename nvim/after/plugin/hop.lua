require('hop').setup()

vim.keymap.set('n', '<TAB>', vim.cmd.HopWord)
vim.keymap.set('n', '<leader>j', vim.cmd.HopWord)

vim.keymap.set('n', '<S-TAB>', vim.cmd.HopWordMW)
vim.keymap.set('n', '<leader>k', vim.cmd.HopWordMW)

vim.keymap.set('n', '<leader>hc', vim.cmd.HopChar1)
vim.keymap.set('n', '<M-j>', vim.cmd.HopChar1)

-- vim.keymap.set('n', '<leader>S', vim.cmd.HopChar1MW)
vim.keymap.set('n', '<leader>hx', vim.cmd.HopChar1MW)
vim.keymap.set('n', '<M-k>', vim.cmd.HopChar1MW)
