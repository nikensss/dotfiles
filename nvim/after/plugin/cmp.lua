local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

require('luasnip.loaders.from_vscode').lazy_load()

local ls = require('luasnip')
ls.add_snippets('all', {
	ls.parser.parse_snippet({ trig = 'co' }, 'console.log({ ${1:name} });'),
	ls.parser.parse_snippet({ trig = 'cl' }, 'console.log(${1});'),
	ls.parser.parse_snippet({ trig = 'str' }, 'JSON.stringify(${1}, null, 2)'),
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
		['<C-e>'] = cmp.mapping.close(),
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
		{ name = 'luasnip', priority = 1000 }, -- snippets with high priority
		{ name = 'nvim_lsp', priority = 750 },
	}, {
		{ name = 'buffer' }, -- text within current buffer
		{ name = 'path' }, -- file system paths
	}),
	-- configure lspkind for vs-code like pictograms in completion menu
	formatting = {
		expandable_indicator = true,
		format = require('lspkind').cmp_format({
			maxwidth = 50,
			ellipsis_char = '...',
		}),
	},
})

vim.keymap.set({ 'n', 'i', 's' }, '<c-f>', function()
	if not require('noice.lsp').scroll(4) then
		return '<c-f>'
	end
end, { silent = true, expr = true })

vim.keymap.set({ 'n', 'i', 's' }, '<c-b>', function()
	if not require('noice.lsp').scroll(-4) then
		return '<c-b>'
	end
end, { silent = true, expr = true })
