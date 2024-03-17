local api = require('nvim-tree.api')

local options = {}
options.desc = '[f]ile [s]ystem'
vim.keymap.set('n', '<leader>fs', function()
	api.tree.focus({ find_file = true })
end, options)
