vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>w', vim.cmd.write)
vim.keymap.set('n', '<leader>qa', vim.cmd.quitall)
vim.keymap.set('n', '<leader>qc', vim.cmd.cclose)

vim.keymap.set('x', '<leader>p', [["_dP]])

vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv')
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv')

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')

vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', 'Q', '<nop>')

vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format)

vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>x', '<cmd>!chmod u+x %<CR>', { silent = true })

-- increment/decrement amount
vim.keymap.set('n', '+', '<C-a>')
vim.keymap.set('n', '-', '<C-x>')

-- resize windows
vim.keymap.set('n', '<leader>+', '5<C-w>>')
vim.keymap.set('n', '<leader>-', '5<C-w><')
vim.keymap.set('n', '<leader><leader>+', '<C-w>15+')
vim.keymap.set('n', '<leader><leader>-', '<C-w>15-')

-- split vertically and move to the right
vim.keymap.set('n', '<C-w><C-v>', '<C-w>v<C-w>l')

-- open terminal in vertical split
vim.keymap.set('n', '<C-w><C-t>', '<C-w>v<C-w>l:terminal<CR>a')

-- colorschemes
vim.keymap.set('n', '<leader><leader>ca', function()
	vim.cmd.colorscheme('catppuccin')
	vim.cmd.Catppuccin('mocha')
end)
vim.keymap.set('n', '<leader><leader>cb', function()
	vim.cmd.colorscheme('catppuccin')
	vim.cmd.Catppuccin('macchiato')
end)
vim.keymap.set('n', '<leader><leader>cc', function()
	vim.cmd.colorscheme('catppuccin')
	vim.cmd.Catppuccin('frappe')
end)
vim.keymap.set('n', '<leader><leader>cd', function()
	vim.cmd.colorscheme('catppuccin')
	vim.cmd.Catppuccin('latte')
end)

vim.keymap.set('n', '<leader><leader>ta', function()
	vim.cmd([[colorscheme tokyonight-night]])
end)
vim.keymap.set('n', '<leader><leader>tb', function()
	vim.cmd([[colorscheme tokyonight-storm]])
end)
vim.keymap.set('n', '<leader><leader>tc', function()
	vim.cmd([[colorscheme tokyonight-moon]])
end)
vim.keymap.set('n', '<leader><leader>td', function()
	vim.cmd([[colorscheme tokyonight-day]])
end)
