local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

require('luasnip.loaders.from_vscode').lazy_load()

local ls = require('luasnip')
ls.add_snippets('all', {
	ls.parser.parse_snippet({ trig = 'co', wordTrig = true }, 'console.log({ ${1:name} })'),
})

cmp.setup({
	snippet = { -- configure how nvim-cmp interacts with snippet engine
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-e>'] = cmp.mapping.close(),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-l>'] = cmp.mapping.complete(),
		['<C-n>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item(cmp_select)
			elseif ls.jumpable(1) then
				ls.jump(1)
			end
		end),
		['<C-p>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item(cmp_select)
			elseif ls.jumpable(-1) then
				ls.jump(-1)
			end
		end),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	-- sources for autocompletion
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' }, -- snippets
	}, {
		{ name = 'buffer' }, -- text within current buffer
		{ name = 'path' }, -- file system paths
	}),
	-- configure lspkind for vs-code like pictograms in completion menu
	formatting = {
		format = require('lspkind').cmp_format({
			maxwidth = 50,
			ellipsis_char = '...',
		}),
	},
})
