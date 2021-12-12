set completeopt=menuone,noselect,noinsert

" NOTE: Order is important. You can't lazy loading lexima.vim.
let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()

lua<<EOF

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local has_any_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local press = function(key)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
end


local cmp = require'cmp'
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            vim.fn["UltiSnips#JumpForwards"]()
          elseif has_any_words_before() then
            press("<Tab>")
          else
            fallback()
          end
        end, {
          "i",
          "s",
          -- add this line when using cmp-cmdline:
          -- "c",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
					elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
            vim.fn["UltiSnips#JumpBackwards"]()
          else
            fallback()
          end
        end, {
          "i",
          "s",
          -- add this line when using cmp-cmdline:
          -- "c",
		}),
		['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
		['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
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
		['<C-Space>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
              vim.fn["UltiSnips#ExpandSnippet"]()
            end
            cmp.select_next_item()
          elseif has_any_words_before() then
            press("<Space>")
          else
            fallback()
          end
        end, {
          "i",
          "s",
          -- add this line when using cmp-cmdline:
          -- "c",
		}),
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
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
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'ultisnips' }, 
	}, {
		{ name = 'buffer' },
	})
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
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['tsserver'].setup {
	capabilities = capabilities
}
require('lspconfig')['rust_analyzer'].setup {
	capabilities = capabilities
}
EOF
