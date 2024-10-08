return {
		'sindrets/diffview.nvim',
		config = function()
			local actions = require('diffview.actions')

			require('diffview').setup({
				keymaps = {
					file_panel = {
						['<tab>'] = false,
						['<s-tab>'] = false,
						{
							'n',
							'<c-n>',
							actions.select_next_entry,
							{ desc = 'Open the diff for the next file' },
						},
						{
							'n',
							'<c-p>',
							actions.select_prev_entry,
							{ desc = 'Open the diff for the previous file' },
						},
					},
				},
			})
		end,
	}
