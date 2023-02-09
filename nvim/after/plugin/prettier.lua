local null_ls = require('null-ls')

null_ls.setup()

local prettier = require('prettier')

prettier.setup({
    bin = 'prettierd', -- or 'prettier'
    filetypes = {
        'css',
        'graphql',
        'html',
        'javascript',
        'javascriptreact',
        'json',
        'less',
        'markdown',
        'scss',
        'typescript',
        'typescriptreact',
        'yaml',
    },
})
