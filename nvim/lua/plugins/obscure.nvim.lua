return {
	'killitar/obscure.nvim',
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.cmd.colorscheme('obscure')
	end,
}
