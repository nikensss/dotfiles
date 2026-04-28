return function()
	require('luasnip.loaders.from_vscode').lazy_load()

	local ls = require('luasnip')
	ls.add_snippets('all', {
		ls.parser.parse_snippet({ trig = 'co' }, 'console.log({ ${1:name} });'),
		ls.parser.parse_snippet({ trig = 'cl' }, 'console.log(${1});'),
		ls.parser.parse_snippet({ trig = 'str' }, 'JSON.stringify(${1}, null, 2)'),
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
end
