require('typescript-tools').setup({})

vim.keymap.set('n', '<leader>to', function()
	vim.cmd.TSToolsOrganizeImports()
end, { desc = 'Remove organize imports' })

vim.keymap.set('n', '<leader>ts', function()
	vim.cmd.TSToolsSortImports()
end, { desc = 'Remove sort imports' })

vim.keymap.set('n', '<leader>tr', function()
	vim.cmd.TSToolsRemoveUnused()
end, { desc = 'Remove unused statements' })

vim.keymap.set('n', '<leader>tx', function()
	vim.cmd.TSToolsRemoveUnusedImports()
end, { desc = 'Remove unused imports' })
