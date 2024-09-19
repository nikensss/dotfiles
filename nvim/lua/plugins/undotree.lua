return {
		'mbbill/undotree',
		keys = { '<leader>ut' },
		config = function()
			local options = { silent = true, noremap = true, desc = '[undotree] toggle undotree' }
			vim.keymap.set('n', '<leader>ut', '<cmd>UndotreeToggle<cr>', options)
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	}
