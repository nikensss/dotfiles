vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
vim.keymap.set('n', '<leader>gb', function() vim.cmd.Git('blame') end)
vim.keymap.set('n', '<leader>gp', function() vim.cmd.Git('push') end)

vim.keymap.set('n', '<leader><leader>gl', [[ :diffget //3<CR> ]])
vim.keymap.set('n', '<leader><leader>gh', [[ :diffget //2<CR> ]])

vim.keymap.set('n', '<leader>gl', [[ :0Gclog<CR> ]])
vim.keymap.set('v', '<leader>gl', [[ :Gclog<CR> ]])

vim.keymap.set('n', '<leader><leader>gd', function()
  local current_file = vim.fn.expand('%')
  local commit_hash = current_file:match("/.git//([0-9a-fA-F]+)")

  if not commit_hash then
    return
  end

  local qf_list = vim.fn.getqflist()
  for i, item in ipairs(qf_list) do
    local qf_list_item_hash = item.module:match("([0-9a-fA-F]+)")

    if commit_hash:find("^" .. qf_list_item_hash) then
      local next_commit_hash = qf_list[i + 1] and qf_list[i + 1].module:match("([0-9a-fA-F]+)")
      if next_commit_hash then
        vim.cmd('Gvdiffsplit ' .. next_commit_hash)
      else
        print("no next commit in quickfix list")
      end
      return
    end
  end

  print("current commit not found in quickfix list")
end)
