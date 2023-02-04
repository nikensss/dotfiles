require('ricard.lazy')
require('ricard.set')
require('ricard.remap')

vim.api.nvim_create_augroup('neotree', {})
vim.api.nvim_create_autocmd('UiEnter', {
  desc = 'Open Neotree automatically',
  group = 'neotree',
  command = 'Neotree<CR><C-w>o'
})
