return {
		'elixir-tools/elixir-tools.nvim',
		version = '*',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			require('elixir').setup()
		end,
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	}
