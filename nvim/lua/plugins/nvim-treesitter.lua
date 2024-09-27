return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdateSync',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-context',
		'nvim-treesitter/nvim-treesitter-refactor',
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
}
