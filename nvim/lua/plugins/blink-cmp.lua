return {
	{
		'saghen/blink.cmp',
		version = '*',
		event = { 'InsertEnter', 'CmdlineEnter' },
		dependencies = {
			{ 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
			'rafamadriz/friendly-snippets',
			'onsails/lspkind.nvim',
			{ 'saghen/blink.compat', version = '*', opts = {} },
		},
		opts = {
			snippets = { preset = 'luasnip' },
			keymap = { preset = 'default' },
			appearance = { nerd_font_variant = 'mono' },
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
				per_filetype = {
					sql = { 'dadbod', 'buffer' },
					mysql = { 'dadbod', 'buffer' },
					plsql = { 'dadbod', 'buffer' },
				},
				providers = {
					lazydev = {
						name = 'LazyDev',
						module = 'lazydev.integrations.blink',
						score_offset = 100,
					},
					dadbod = {
						name = 'dadbod',
						module = 'blink.compat.source',
						opts = { name = 'vim-dadbod-completion' },
					},
				},
			},
			cmdline = {
				keymap = { preset = 'cmdline' },
				completion = { menu = { auto_show = true } },
			},
			signature = { enabled = true },
		},
		opts_extend = { 'sources.default' },
	},
}
