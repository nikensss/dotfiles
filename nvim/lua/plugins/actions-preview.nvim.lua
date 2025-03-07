return {
	'aznhe21/actions-preview.nvim',
	config = function()
		vim.keymap.set({ 'v', 'n' }, '<leader>ca', require('actions-preview').code_actions)
	end,
}
