return {
	'nvim-treesitter/nvim-treesitter',
	branch = 'master', -- Use master branch for backward compatibility with textobjects
	build = ':TSUpdate',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-context',
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
}
