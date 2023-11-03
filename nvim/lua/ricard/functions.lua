local M = {}

function M.get_current_folder_name()
	local path = vim.fn.getcwd()
	local parts = {}
	for part in string.gmatch(path, '[^/]+') do
		table.insert(parts, part)
	end
	return parts[#parts]
end

return M
