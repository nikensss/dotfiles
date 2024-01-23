require('hop').setup()

vim.keymap.set('n', 's', vim.cmd.HopWord, { desc = '[hop] hop word' })
vim.keymap.set('n', 'S', vim.cmd.HopWordMW, { desc = '[hop] hop word multi window' })
vim.keymap.set('n', '<C-s>', vim.cmd.HopChar1, { desc = '[hop] hop char' })

vim.keymap.set('n', '<leader>j', vim.cmd.HopWord, { desc = '[hop] hop word' })
vim.keymap.set('n', '<M-j>', vim.cmd.HopWordMW, { desc = '[hop] hop word multi window' })

vim.keymap.set('n', '<leader>k', vim.cmd.HopChar1, { desc = '[hop] hop char' })
vim.keymap.set('n', '<M-k>', vim.cmd.HopChar1MW, { desc = '[hop] hop char multi window' })

vim.keymap.set('n', '<M-l>', vim.cmd.HopLine, { desc = '[hop] hop line' })
