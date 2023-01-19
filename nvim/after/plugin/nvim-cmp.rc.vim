" NOTE: Order is important. You can't lazy loading lexima.vim.
let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()

lua<<EOF

require "lsp_signature".setup()

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300)

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
		['<C-n>'] = cmp.mapping({
				c = function()
						if cmp.visible() then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						else
								vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
						end
				end,
				i = function(fallback)
						if cmp.visible() then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						else
								fallback()
						end
				end
		}),
		['<C-p>'] = cmp.mapping({
				c = function()
						if cmp.visible() then
								cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
						else
								vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
						end
				end,
				i = function(fallback)
						if cmp.visible() then
								cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
						else
								fallback()
						end
				end
		}),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
		['<CR>'] = cmp.mapping({
				i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
				c = function(fallback)
						if cmp.visible() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
						else
								fallback()
						end
				end
		}),
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

cmp.setup.cmdline('/', {
    completion = { autocomplete = false },
    sources = {
        { name = 'buffer', opts = { keyword_pattern = [=[[^[:blank:]].*]=] } }
    }
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
    completion = { autocomplete = false },
    sources = cmp.config.sources({
        { name = 'path' }
        }, {
        { name = 'cmdline' }
    })
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig')['tsserver'].setup {
	capabilities = capabilities
}
EOF
