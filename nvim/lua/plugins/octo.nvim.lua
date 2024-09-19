return {
		'pwntester/octo.nvim',
		config = function()
			require('octo').setup({ enable_builtin = true })
		end,
		keys = {
			{ '<leader>o', '<cmd>Octo<CR>', desc = 'Octo' },
		},
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
			'nvim-tree/nvim-web-devicons',
		},
	}
