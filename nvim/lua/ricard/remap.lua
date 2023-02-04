vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)


vim.keymap.set('n', '<leader>w', vim.cmd.write)
vim.keymap.set('n', '<leader>qa', vim.cmd.quitall)

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')

vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', 'Q', '<nop>')

vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

-- increment/decrement amount
vim.keymap.set('n','+','<C-a>')
vim.keymap.set('n','-','<C-x>')

-- resize windows
vim.keymap.set('n','<leader>+','5<C-w>>')
vim.keymap.set('n','<leader>-','5<C-w><')
vim.keymap.set('n','<leader><leader>+','<C-w>15+')
vim.keymap.set('n','<leader><leader>-','<C-w>15-')
vim.keymap.set('n','<leader><leader>-','<C-w>15-')

-- Terminal in neovim
_G.term_buf_of_tab = _G.term_buf_of_tab or {}
_G.term_buf_max_nmb = _G.term_buf_max_nmb or 0

function Spawn_terminal()
  local cur_tab = vim.api.nvim_get_current_tabpage()
  vim.cmd('vs | terminal')
  local cur_buf = vim.api.nvim_get_current_buf()
  _G.term_buf_max_nmb = _G.term_buf_max_nmb + 1
  vim.api.nvim_buf_set_name(cur_buf, 'Terminal ' .. _G.term_buf_max_nmb)
  table.insert(_G.term_buf_of_tab, cur_tab, cur_buf)
  vim.cmd(':startinsert')
end

function Toggle_terminal()
  local cur_tab = vim.api.nvim_get_current_tabpage()
  local term_buf = term_buf_of_tab[cur_tab]
  if term_buf ~= nil then
   local cur_buf = vim.api.nvim_get_current_buf()
   if cur_buf == term_buf then
     vim.cmd('q')
   else
     vim.cmd('vert sb' .. term_buf)
     vim.cmd(':startinsert')
   end
  else
    Spawn_terminal()
    vim.cmd(':startinsert')
  end
end

vim.keymap.set('n', '<C-t>', Toggle_terminal)
vim.keymap.set('n', '<leader>tr', [[:lua Toggle_terminal()<CR><C-\><C-n><C-w>Ti]])
vim.keymap.set('t', '<ESC>', '<c-\\><c-n>')
