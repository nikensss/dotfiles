return {
	'nvim-treesitter/nvim-treesitter',
	branch = 'main',
	lazy = false,
	build = ':TSUpdate',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-context',
		{
			'nvim-treesitter/nvim-treesitter-textobjects',
			branch = 'main',
			init = function()
				vim.g.no_plugin_maps = true
			end,
		},
	},
}
