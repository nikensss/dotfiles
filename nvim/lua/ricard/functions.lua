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
	return vim.fn.system('git branch --show-current 2> /dev/null | tr -d \'\n\'')
end

function M.get_session_path()
	local fixed_branch_name = string.gsub(M.get_branch_name(), '/', '_')
	local session_name = M.get_current_folder_name() .. '__' .. fixed_branch_name .. '.session'

	return vim.fn.expand('~/.config/nvim/' .. session_name)
end

function M.get_qf_list_path()
	local qf_list_name = string.gsub(M.get_session_path(), '.session$', '.qf')
	return vim.fn.expand('~/.config/nvim/' .. qf_list_name)
end

function M.save_qf_list()
	local qf_list_path = M.get_qf_list_path()

	local qf_list = vim.fn.getqflist()
	for _, item in ipairs(qf_list) do
		if item.bufnr then
			item.filename = vim.api.nvim_buf_get_name(item.bufnr)
			item.bufnr = nil
		end
	end

	local json = vim.fn.json_encode(qf_list)

	local file = io.open(qf_list_path, 'w')
	if file then
		file:write(json)
		file:close()
	else
		print('error: could not open qf_list file for writing')
	end
end

function M.load_qf_list(path)
	local qf_list_path = M.get_qf_list_path()
	if path ~= nil then
		qf_list_path = vim.fn.expand(path)
	end

	local file = io.open(qf_list_path, 'r')
	if file == nil then
		print('error: could not open qf_list file for reading (' .. qf_list_path .. ')')
		return
	end

	local json = file:read('*a')
	file:close()

	local qf_list = vim.fn.json_decode(json)
	for _, item in ipairs(qf_list) do
		if item.filename then
			local bufnr = vim.fn.bufnr(item.filename)
			if bufnr == -1 then
				bufnr = vim.fn.bufadd(item.filename)
			end
			item.bufnr = bufnr
			item.filename = nil
		end
	end

	if #qf_list <= 0 then
		return
	end

	vim.fn.setqflist({}, 'r', { items = qf_list })

	local cursor_win = vim.api.nvim_get_current_win()
	local cursor_pos = vim.api.nvim_win_get_cursor(cursor_win)

	vim.cmd('copen')
	vim.cmd('wincmd J')

	vim.api.nvim_set_current_win(cursor_win)
	vim.api.nvim_win_set_cursor(0, cursor_pos)
end

function M.get_buffers_in_tabs()
	local tabs_buffers = {}
	local tabs = vim.api.nvim_list_tabpages()

	for _, tab in ipairs(tabs) do
		local windows = vim.api.nvim_tabpage_list_wins(tab)
		local buffer_names = {}

		for _, win in ipairs(windows) do
			local buf = vim.api.nvim_win_get_buf(win)
			local name = vim.api.nvim_buf_get_name(buf)
			table.insert(buffer_names, name)
		end

		tabs_buffers[tab] = buffer_names
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

function M.is_deno_project()
	-- Check for deno.json or deno.jsonc in the current directory and upwards
	local filepath = vim.fn.expand('%:p:h') -- Get the full path of the current file's directory
	local deno_file_found = vim.fn.findfile('deno.json', filepath .. ';') ~= ''
		or vim.fn.findfile('deno.jsonc', filepath .. ';') ~= ''
	return deno_file_found
end

return M
