return {
		'ray-x/go.nvim',
		dependencies = { -- optional packages
			'ray-x/guihua.lua',
			'neovim/nvim-lspconfig',
			'nvim-treesitter/nvim-treesitter',
			'leoluz/nvim-dap-go',
		},
		config = function()
			require('go').setup({
				dap_debug_keymap = false,
			})
		end,
		event = { 'CmdlineEnter' },
		ft = { 'go', 'gomod' },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	}
