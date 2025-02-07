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
						'<c-e>',
						actions.scroll_view(1),
						{ desc = 'Scroll the diff 5 lines down' },
					},
					{
						'n',
						'<c-y>',
						actions.scroll_view(-1),
						{ desc = 'Scroll the diff 5 lines down' },
					},
					{
						'n',
						'<c-d>',
						actions.scroll_view(5),
						{ desc = 'Scroll the diff 5 lines down' },
					},
					{
						'n',
						'<c-u>',
						actions.scroll_view(-5),
						{ desc = 'Scroll the diff 5 lines up' },
					},
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
