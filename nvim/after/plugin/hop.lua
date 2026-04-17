require('hop').setup()

vim.keymap.set('n', 's', vim.cmd.HopWord, { desc = '[hop] hop word' })
vim.keymap.set('n', 'S', vim.cmd.HopWordMW, { desc = '[hop] hop word multi window' })

vim.keymap.set('n', '<leader>j', vim.cmd.HopWord, { desc = '[hop] hop word' })
vim.keymap.set('n', '<leader>J', vim.cmd.HopWordMW, { desc = '[hop] hop word multi window' })

vim.keymap.set('n', '<leader>k', vim.cmd.HopLine, { desc = '[hop] hop line' })
vim.keymap.set('n', '<leader>K', vim.cmd.HopLineMW, { desc = '[hop] hop line multi window' })
