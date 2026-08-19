return {
	'sindrets/diffview.nvim',
	config = function()
		local actions = require('diffview.actions')

		-- Summoning the panel drops the cursor on the file that is open in the diff. diffview only highlights the
		-- current file while the panel is open, so a panel that was closed while switching files opens out of sync.
		local function toggle_file_panel()
			local view = require('diffview.lib').get_current_view()

			if not view then
				return
			end

			view.panel:toggle(true)

			if view.panel:is_open() then
				view.panel:highlight_cur_file()
			end
		end

		require('diffview').setup({
			file_panel = {
				win_config = function()
					local editor_width = vim.o.columns
					local editor_height = vim.o.lines - vim.o.cmdheight - 1
					local width = math.floor(editor_width * 0.5)
					local height = math.floor(editor_height * 0.8)

					return {
						type = 'float',
						relative = 'editor',
						border = 'rounded',
						width = width,
						height = height,
						col = math.floor((editor_width - width) / 2),
						row = math.floor((editor_height - height - 2) / 2),
					}
				end,
			},
			hooks = {
				-- The file panel is summoned with <leader>fs, so a view starts without it.
				view_opened = function(view)
					local DiffView = require('diffview.scene.views.diff.diff_view').DiffView

					if view:instanceof(DiffView) then
						view.panel:close()
					end
				end,
			},
			keymaps = {
				view = {
					{
						'n',
						'<leader>fs',
						toggle_file_panel,
						{ desc = 'Toggle the file panel' },
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
				file_panel = {
					['<tab>'] = false,
					['<s-tab>'] = false,
					{
						'n',
						'<leader>fs',
						toggle_file_panel,
						{ desc = 'Toggle the file panel' },
					},
					{
						'n',
						'q',
						actions.toggle_files,
						{ desc = 'Close the file panel' },
					},
					{
						'n',
						'<esc>',
						actions.toggle_files,
						{ desc = 'Close the file panel' },
					},
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
