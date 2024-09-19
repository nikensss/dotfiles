return {
		'kndndrj/nvim-dbee',
		dependencies = {
			'MunifTanjim/nui.nvim',
		},
		build = function()
			require('dbee').install()
		end,
		config = function()
			require('dbee').setup({
				sources = {
					require('dbee.sources').EnvSource:new('DBEE_CONNECTIONS'),
				},
				result = {
					page_size = 100000,
				},
			})
		end,
		keys = {
			{ '<leader><leader>pg', '<cmd>lua require"dbee".toggle()<CR>', desc = '[dbee] toggle' },
		},
	}
