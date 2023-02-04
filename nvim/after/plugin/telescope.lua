local builtin = require('telescope.builtin')
local options = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>sf', builtin.find_files, options)
vim.keymap.set('n', '<leader>sh', builtin.help_tags, options)
vim.keymap.set('n', '<leader>sp', builtin.git_files, options)
vim.keymap.set('n', '<leader>sg', builtin.live_grep, options)
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, options)

vim.keymap.set('n', '<leader><space>', builtin.buffers, options)

