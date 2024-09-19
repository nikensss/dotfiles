return {
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdateSync',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-context',
			'nvim-treesitter/nvim-treesitter-refactor',
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		config = function()
			vim.keymap.set('n', '<leader>fq', '<cmd>NvimTreeClose<cr>', { desc = '[nvim-tree] close', silent = true })
		end,
	}
