local lsp = require('lsp-zero')
local nvim_lsp = require('lspconfig')

lsp.preset('recommended')

lsp.ensure_installed({
    'eslint',
    'jsonls',
    'prismals',
    -- 'prettierd',
    'rust_analyzer',
    'sumneko_lua',
    'tsserver',
})

-- Set up sumneko_lua according to the
-- recommended settings by nvim-lspconfig
lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
            telemetry = { enable = false }
        }
    }
})

lsp.configure('tsserver', {
    root_dir = nvim_lsp.util.root_pattern('package.json'),
    single_file_support = false,
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-b>'] = cmp.mapping.scroll_docs( -4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-j>'] = cmp.mapping.complete(),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    })

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false
})

local lsp_formatting_augroup = vim.api.nvim_create_augroup('LspFormatting', {})

lsp.on_attach(function(client, bufnr)
  -- make sure only null-ls is used to format typescript
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = lsp_formatting_augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = lsp_formatting_augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
              filter = function(filter_client)
                return filter_client.name ~= 'tsserver'
              end,
              bufnr = bufnr,
          })
        end
    })
  end

  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, remap = false })
  end

  nmap('<leader>rn', vim.lsp.buf.rename)
  nmap('<leader>ca', vim.lsp.buf.code_action)

  nmap('gd', vim.lsp.buf.definition)
  nmap('gr', require('telescope.builtin').lsp_references)
  nmap('gI', vim.lsp.buf.implementation)
  nmap('gy', vim.lsp.buf.type_definition)
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols)

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature help', remap = false })
end)

vim.diagnostic.config({
    virtual_text = true
})

local function lspSymbol(name, icon)
  vim.fn.sign_define('DiagnosticSign' .. name, { text = icon, numhl = 'DiagnosticDefault' .. name })
end

lspSymbol('Error', '')
lspSymbol('Information', '')
lspSymbol('Hint', '')
lspSymbol('Info', '')
lspSymbol('Warning', '')

lsp.setup()
