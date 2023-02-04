local builtin = require('telescope.builtin')
local options = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>pf', builtin.find_files, options)
vim.keymap.set('n', '<leader>ff', builtin.git_files, options)
vim.keymap.set('n', '<leader>ps', builtin.live_grep, options)
