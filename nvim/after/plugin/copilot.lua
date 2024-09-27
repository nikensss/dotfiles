vim.keymap.set(
	'i',
	'<C-j>',
	'copilot#Accept("\\<CR>")',
	{ expr = true, replace_keycodes = false, desc = '[copilot] accept completion' }
)
vim.keymap.set('i', '<M-w>', '<Plug>(copilot-accept-word)', { noremap = false, desc = '[copilot] accept word' })
vim.keymap.set('n', '<leader>cp', '<cmd>Copilot panel<CR>', { noremap = true, desc = '[copilot] open panel' })

vim.g.copilot_no_tab_map = true
