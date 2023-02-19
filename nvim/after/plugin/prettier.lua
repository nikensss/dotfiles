local null_ls = require('null-ls')

null_ls.setup()

local prettier = require('prettier')

prettier.setup({
  bin = 'prettierd', -- or 'prettier'
})
