return {
	'rcarriga/nvim-dap-ui',
	dependencies = {
		'mfussenegger/nvim-dap',
		'nvim-neotest/nvim-nio',
		'theHamsta/nvim-dap-virtual-text',
		'nvim-telescope/telescope.nvim',
		'nvim-telescope/telescope-dap.nvim',
	},
	config = function()
		dofile(vim.fn.stdpath('config') .. '/after/plugin/dap.lua')()
	end,
}
