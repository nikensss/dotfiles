return {
	'rmagatti/goto-preview',
	dependencies = { 'rmagatti/logger.nvim' },
	config = function()
		require('goto-preview').setup({
			default_mappings = true,
			height = 45,
			post_open_hook = function()
				local bufnr = vim.api.nvim_get_current_buf()
				vim.keymap.set('n', 'q', '<C-w>q', { noremap = true, silent = true, buffer = bufnr })
			end,
		})
	end,
}
