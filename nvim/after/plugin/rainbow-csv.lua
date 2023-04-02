local options = { noremap = true, silent = false }

vim.keymap.set('n', '<leader>rba', vim.cmd.RainbowAlign, options)
vim.keymap.set('n', '<leader>rbd', vim.cmd.RainbowDelim, options)
