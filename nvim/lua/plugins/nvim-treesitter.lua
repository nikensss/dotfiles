return {
	'nvim-treesitter/nvim-treesitter',
	branch = 'master', -- Use master branch for backward compatibility with textobjects
	build = ':TSUpdate',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-context',
		{
			'nvim-treesitter/nvim-treesitter-textobjects',
			branch = 'main',
			init = function()
				-- Disable entire built-in ftplugin mappings to avoid conflicts.
				-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
				vim.g.no_plugin_maps = true

				-- Or, disable per filetype (add as you like)
				-- vim.g.no_python_maps = true
				-- vim.g.no_ruby_maps = true
				-- vim.g.no_rust_maps = true
				-- vim.g.no_go_maps = true
			end,
			config = function()
				-- put your config here
			end,
		},
	},
}
