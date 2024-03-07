vim.keymap.set('n', '<leader>si', ':Silicon ~/Desktop/snap.png<CR>', { noremap = true, silent = true })
vim.keymap.set(
	'v',
	'<A-s>',
	':\'<,\'>Silicon ~/Desktop/snap.png<CR> | !osascript -e \'set the clipboard to (read (POSIX file "~/Desktop/snap.png") as JPEG picture)\'',
	{ noremap = true, silent = true }
)
