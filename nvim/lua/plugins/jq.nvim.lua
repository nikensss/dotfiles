return {
	'cenk1cenk2/jq.nvim',
	dependencies = {
		-- https://github.com/nvim-lua/plenary.nvim
		'nvim-lua/plenary.nvim',
		-- https://github.com/MunifTanjim/nui.nvim
		'MunifTanjim/nui.nvim',
		-- https://github.com/grapp-dev/nui-components.nvim
		'grapp-dev/nui-components.nvim',
	},
	config = function()
		vim.keymap.set('n', '<leader>jq', function()
			require('jq').run({
				toggle = true,
				commands = {
					{
						command = 'jq',
						filetype = 'json',
						arguments = '-r',
					},
				},
				arguments = '-r',
				query = '.',
			})
		end)
	end,
}
