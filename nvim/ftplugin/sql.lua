local group = vim.api.nvim_create_augroup('sql_format_on_save', { clear = false })
local event = 'BufWritePost'
vim.api.nvim_clear_autocmds({ group = group })
vim.api.nvim_create_autocmd(event, {
  group = group,
  callback = function()
    -- Capture the content of the entire buffer
    local buf_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

    -- Send the buffer content to your command and capture its output
    local result = vim.fn.system('sleek', buf_content)

    if result and #result > 0 then
      -- Replace the buffer's content with the formatted result
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, '\n'))
    end
  end,
  desc = '[sql] format on save',
})
