vim.keymap.set('n', '<leader>pg', function()
	local tab_index = require('ricard.functions').find_tab_with_buffer('dbui')

	if tab_index == nil then
		vim.cmd.tabe()
		vim.cmd.DBUIToggle()
	else
		vim.api.nvim_set_current_tabpage(tab_index)
	end
end, { desc = 'DBUI' })
