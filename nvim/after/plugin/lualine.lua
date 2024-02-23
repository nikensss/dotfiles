local navic = require('nvim-navic')

require('lualine').setup({
	options = {
		icons_enabled = true,
		theme = 'catppuccin',
		section_separators = { left = '', right = '' },
		component_separators = { left = '', right = '' },
		disabled_filetypes = {},
	},
	winbar = {
		lualine_c = {
			{
				function()
					return navic.get_location()
				end,
				cond = function()
					return navic.is_available()
				end,
			},
		},
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { { 'filename', file_status = true, path = 1 } },
		lualine_x = {
			{
				require('noice').api.statusline.mode.get,
				cond = require('noice').api.statusline.mode.has,
				color = { fg = '#ff9e64' },
			},
			'encoding',
			'fileformat',
			'filetype',
		},
		lualine_y = { 'progress' },
		lualine_z = { 'location' },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { 'fugitive' },
})
