local group = vim.api.nvim_create_augroup('py_format_on_save', { clear = false })
local event = 'BufWritePre'

vim.api.nvim_clear_autocmds({ group = group })
vim.api.nvim_create_autocmd(event, {
  group = group,
  pattern = '*.py',
  callback = function()
    -- Capture the content of the entire buffer
    local buf_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

    -- Send the buffer content to your command and capture its output
    local result = vim.fn.system('black -c' .. vim.fn.shellescape(buf_content))

    if result and #result > 0 then
      -- Replace the buffer's content with the formatted result
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, '\n'))
    end
  end,
  desc = '[py] format on save',
})
