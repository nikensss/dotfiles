return {
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer', -- source for text in buffer
			'hrsh7th/cmp-path', -- source for file system paths
			'hrsh7th/cmp-cmdline',
			{ 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' }, -- snippet engine
			'saadparwaiz1/cmp_luasnip', -- for autocompletion
			'rafamadriz/friendly-snippets', -- useful snippets
			'onsails/lspkind.nvim', -- vs-code like pictograms
		},
	}
