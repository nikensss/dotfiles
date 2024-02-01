local M = {}

function M.get_current_folder_name()
	local path = vim.fn.getcwd()
	local parts = {}
	for part in string.gmatch(path, '[^/]+') do
		table.insert(parts, part)
	end
	return parts[#parts]
end

function M.get_branch_name()
	local branch = vim.fn.system('git branch --show-current 2> /dev/null | tr -d \'\n\'')
	if branch ~= '' then
		return branch
	else
		return ''
	end
end

function M.get_session_path()
	local fixed_branch_name = string.gsub(M.get_branch_name(), '/', '_')
	local session_name = M.get_current_folder_name() .. '__' .. fixed_branch_name .. '.session'
	local session_path = vim.fn.expand('~/.config/nvim/' .. session_name)

	return session_path
end

function M.get_buffers_in_tabs()
	local tabs_buffers = {}
	local tabs = vim.api.nvim_list_tabpages()

	for tab_index, tab in ipairs(tabs) do
		local windows = vim.api.nvim_tabpage_list_wins(tab)
		local buffer_names = {}

		for _, win in ipairs(windows) do
			local buf = vim.api.nvim_win_get_buf(win)
			local name = vim.api.nvim_buf_get_name(buf)
			table.insert(buffer_names, name)
		end

		tabs_buffers[tab_index] = buffer_names
	end

	return tabs_buffers
end

function M.find_tab_with_buffer(buffer_name)
	local buffers_in_tabs = M.get_buffers_in_tabs()

	for tab_index, buffers in pairs(buffers_in_tabs) do
		for _, name in ipairs(buffers) do
			if name:find(buffer_name) then -- Check if the buffer name contains the specified name
				return tab_index -- Return the tab index
			end
		end
	end

	return nil
end

function M.get_key_from_table(table, value)
	for k, v in pairs(table) do
		if v == value then
			return k
		end
	end

	return nil
end

return M
