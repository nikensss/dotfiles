return {
		'LukasPietzschmann/telescope-tabs',
		config = function()
			require('telescope').load_extension('telescope-tabs')

			vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

			require('telescope-tabs').setup({
				entry_formatter = function(tab_id, _, _, _, is_current)
					local tab_name = require('tabby.feature.tab_name').get(tab_id)
					return string.format('%d: %s%s', tab_id, tab_name, is_current and ' <' or '')
				end,
				entry_ordinal = function(tab_id)
					return require('tabby.feature.tab_name').get(tab_id)
				end,
			})

			require('tabby.tabline').use_preset('tab_only')
			vim.keymap.set('n', '<leader>tr', [[ :TabRename ]])
		end,
		dependencies = { 'nvim-telescope/telescope.nvim', 'nanozuki/tabby.nvim' },
	}
