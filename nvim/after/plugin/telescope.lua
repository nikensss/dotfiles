local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local trouble = require('trouble.providers.telescope')

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

-- options.desc = '[s]how [d]iagnostics'
-- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, options)

options.desc = '[s]earch in [c]urrent buffer (fuzzy find)'
vim.keymap.set('n', '<leader>sc', builtin.current_buffer_fuzzy_find, options)

options.desc = '[s]how [k]eymaps'
vim.keymap.set('n', '<leader>sk', builtin.keymaps, options)

options.desc = '[c]ommand [h]istory'
vim.keymap.set('n', '<leader>ch', builtin.command_history, options)

options.desc = '[c]urrent buffer [s]ymbols'
vim.keymap.set('n', '<leader>cs', builtin.lsp_document_symbols, options)

options.desc = '[s]ymbols in [w]orkspace'
vim.keymap.set('n', '<leader>sw', builtin.lsp_workspace_symbols, options)

options.desc = 'dynamic workspace [[s]]ymbols'
vim.keymap.set('n', '<leader>ss', builtin.lsp_dynamic_workspace_symbols, options)

options.desc = '[s]how [j]umplist'
vim.keymap.set('n', '<leader>sj', builtin.jumplist, options)

options.desc = '[s]how [n]otifications'
vim.keymap.set('n', '<leader>sn', ':Telescope notify<CR>', options)

options.desc = '[s]how [m]essages'
vim.keymap.set('n', '<leader>sm', ':Telescope noice<CR>', options)

options.desc = '[s]how ma[r]ks'
vim.keymap.set('n', '<leader>sr', ':Telescope marks<CR>', options)

require('telescope').setup({
	defaults = {
		mappings = {
			n = {
				['<C-d>'] = actions.delete_buffer,
				['<C-s>'] = actions.toggle_selection + actions.move_selection_worse,
				['<C-f>'] = actions.preview_scrolling_down,
				['<C-b>'] = actions.preview_scrolling_up,
				['<C-t>'] = trouble.open_with_trouble,
			},
			i = {
				['<C-d>'] = actions.delete_buffer,
				['<C-s>'] = actions.toggle_selection + actions.move_selection_worse,
				['<C-f>'] = actions.preview_scrolling_down,
				['<C-b>'] = actions.preview_scrolling_up,
				['<C-t>'] = trouble.open_with_trouble,
			},
		},
	},
})

require('telescope').load_extension('git_worktree')
require('telescope').load_extension('noice')
