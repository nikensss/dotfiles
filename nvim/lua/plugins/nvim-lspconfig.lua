return {
	'neovim/nvim-lspconfig',
	event = { 'BufReadPre', 'BufNewFile' },
	dependencies = {
		{
			'folke/neoconf.nvim',
			config = function()
				require('neoconf').setup()
			end,
		},
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/nvim-cmp',
		{
			'antosha417/nvim-lsp-file-operations',
			dependencies = {
				'nvim-lua/plenary.nvim',
			},
			config = function()
				require('lsp-file-operations').setup()
			end,
		},
		{
			'SmiteshP/nvim-navbuddy',
			dependencies = {
				'SmiteshP/nvim-navic',
				'MunifTanjim/nui.nvim',
			},
			opts = { lsp = { auto_attach = true } },
			keys = {
				{
					'<leader>nb',
					function()
						require('nvim-navbuddy').open()
					end,
					desc = 'Open NavBuddy',
				},
			},
		},
	},
}
