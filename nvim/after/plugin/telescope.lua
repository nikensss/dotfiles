local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

local options = { noremap = true, silent = true }

options.desc = '[s]earch with [g]rep'
vim.keymap.set('n', '<leader>sg', builtin.live_grep, options)

options.desc = '[f]ind [c]urrent word'
vim.keymap.set('n', '<leader>fc', builtin.grep_string, options)

options.desc = '[s]earch [f]iles'
vim.keymap.set('n', '<leader>sf', function()
	builtin.find_files({
		file_ignore_patterns = { 'node%_modules/*', '%.git/*', '%.next/*' },
		hidden = true,
		no_ignore = true,
	})
end, options)

options.desc = '[s]earch in [p]roject'
vim.keymap.set('n', '<leader>sp', builtin.git_files, options)

options.desc = '[s]how [b]uffers'
vim.keymap.set('n', '<leader>sb', builtin.buffers, options)

options.desc = '[s]earch [h]elp'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, options)

options.desc = '[s]how [k]eymaps'
vim.keymap.set('n', '<leader>sk', builtin.keymaps, options)

options.desc = '[c]ommand [h]istory'
vim.keymap.set('n', '<leader>ch', builtin.command_history, options)

options.desc = 'fuzzy find current buffer'
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, options)

options.desc = 'fuzzy find symbols current buffer'
vim.keymap.set('n', '<leader><leader>/', builtin.lsp_document_symbols, options)

options.desc = 'find symbols workspace'
vim.keymap.set('n', '<leader>?', builtin.lsp_dynamic_workspace_symbols, options)

options.desc = 'fuzzy find symbols in workspace'
vim.keymap.set('n', '<leader><leader>?', builtin.lsp_workspace_symbols, options)

options.desc = '[s]how [j]umplist'
vim.keymap.set('n', '<leader>sj', builtin.jumplist, options)

options.desc = '[s]how [n]otifications'
vim.keymap.set('n', '<leader>sn', ':Telescope notify<CR>', options)

options.desc = '[s]how [m]essages'
vim.keymap.set('n', '<leader>sm', ':Telescope noice<CR>', options)

options.desc = '[s]how ma[r]ks'
vim.keymap.set('n', '<leader>sr', ':Telescope marks<CR>', options)

options.desc = '[s]how [t]abs'
vim.keymap.set('n', '<leader>st', ':Telescope telescope-tabs list_tabs<CR>', options)

options.desc = '[g]it [b]ranches'
vim.keymap.set('n', '<leader>sj', builtin.git_branches, options)

require('telescope').setup({
	defaults = {
		mappings = {
			n = {
				['<C-d>'] = actions.delete_buffer,
				['<C-s>'] = actions.toggle_selection + actions.move_selection_worse,
				['<C-f>'] = actions.preview_scrolling_down,
				['<C-b>'] = actions.preview_scrolling_up,
				['<C-t>'] = require('trouble.sources.telescope').open,
			},
			i = {
				['<C-d>'] = actions.delete_buffer,
				['<C-s>'] = actions.toggle_selection + actions.move_selection_worse,
				['<C-f>'] = actions.preview_scrolling_down,
				['<C-b>'] = actions.preview_scrolling_up,
				['<C-t>'] = require('trouble.sources.telescope').open,
			},
		},
	},
})

require('telescope').load_extension('noice')
