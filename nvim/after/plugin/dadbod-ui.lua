vim.g.dbui_previous_tab = nil

vim.keymap.set('n', '<leader>pg', function()
	local dadbod = require('ricard.functions').find_tab_with_buffer('dbui')

	if dadbod == nil then
		vim.g.dbui_previous_tab = vim.api.nvim_get_current_tabpage()
		vim.cmd.tabe()
		vim.cmd.DBUIToggle()
		return
	end

	if dadbod == vim.api.nvim_get_current_tabpage() then
		if vim.g.dbui_previous_tab == nil then
			return
		end

		vim.api.nvim_set_current_tabpage(vim.g.dbui_previous_tab)
		return
	end

	vim.g.dbui_previous_tab = vim.api.nvim_get_current_tabpage()
	vim.api.nvim_set_current_tabpage(dadbod)
end, { desc = 'DBUI' })
