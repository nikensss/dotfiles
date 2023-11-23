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

return M
