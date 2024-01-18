vim.g.dbui_previous_tab = nil

vim.keymap.set('n', '<leader>pg', function()
	local db_ui_tab_index = require('ricard.functions').find_tab_with_buffer('dbui')

	if db_ui_tab_index == nil then
		vim.g.dbui_previous_tab = vim.api.nvim_get_current_tabpage()
		vim.cmd.tabe()
		vim.cmd.DBUIToggle()
	elseif db_ui_tab_index == vim.api.nvim_get_current_tabpage() then
		if vim.g.dbui_previous_tab == nil then
			return
		end
		vim.api.nvim_set_current_tabpage(vim.g.dbui_previous_tab)
	else
		vim.g.dbui_previous_tab = vim.api.nvim_get_current_tabpage()
		vim.api.nvim_set_current_tabpage(db_ui_tab_index)
	end
end, { desc = 'DBUI' })
