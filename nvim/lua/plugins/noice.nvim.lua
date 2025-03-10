return {
	'folke/noice.nvim',
	event = 'VeryLazy',
	opts = {
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				['vim.lsp.util.convert_input_to_markdown_lines'] = true,
				['vim.lsp.util.stylize_markdown'] = true,
				['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		views = {
			hover = {
				border = { style = 'rounded' },
				position = { row = 2 },
			},
		},
		routes = {
			{
				filter = {
					event = 'msg_show',
					kind = '',
					find = 'written',
				},
				opts = { skip = true },
			},
		},
	},
	dependencies = {
		'MunifTanjim/nui.nvim',
		'rcarriga/nvim-notify',
	},
}
