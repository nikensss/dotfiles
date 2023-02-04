local lsp = require('lsp-zero')
local nvim_lsp = require('lspconfig')

lsp.preset('recommended')

lsp.ensure_installed({
  'prisma-language-server',
  'rust_analyzer',
  'sumneko_lua',
  'tsserver',
})

-- Set up sumneko_lua according to the
-- recommended settings by nvim-lspconfig
lsp.configure('sumneko_lua', {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false }
    }
  }
})

lsp.configure('tsserver', {
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false,
})


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-j>'] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[a", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]a", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

nvim_lsp.diagnosticls.setup({
	filetypes = {
		"javascript",
		"javascriptreact",
		"json",
		"typescript",
		"typescriptreact",
	},
	init_options = {
		linters = {
			eslint = {
				command = "eslint_d",
				rootPatterns = { ".eslintrc.json" },
				debounce = 100,
				args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
				sourceName = "eslint_d",
				parseJson = {
					errorsRoot = "[0].messages",
					line = "line",
					column = "column",
					endLine = "endLine",
					endColumn = "endColumn",
					message = "[eslint] ${message} [${ruleId}]",
					security = "severity",
				},
				securities = {
					[2] = "error",
					[1] = "warning",
				},
			},
		},
		filetypes = {
			javascript = "eslint",
			javascriptreact = "eslint",
			typescript = "eslint",
			typescriptreact = "eslint",
		},
	},
})
