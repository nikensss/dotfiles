require('typescript-tools').setup({})

vim.keymap.set('n', '<leader>tso', vim.cmd.TSToolsOrganizeImports, { desc = '[ts-tools] organize imports' })

vim.keymap.set('n', '<leader>tss', vim.cmd.TSToolsSortImports, { desc = '[ts-tools] sort imports' })

vim.keymap.set('n', '<leader>tsr', vim.cmd.TSToolsRemoveUnused, { desc = '[ts-tools] remove unused statements' })

vim.keymap.set('n', '<leader>tsx', vim.cmd.TSToolsRemoveUnusedImports, { desc = '[ts-tools] remove unused imports' })

vim.keymap.set('n', '<leader>tsa', vim.cmd.TSToolsAddMissingImports, { desc = '[ts-tools] add missing imports' })
