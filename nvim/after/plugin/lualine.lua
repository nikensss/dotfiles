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
					if not navic.is_available() then
						return ''
					end

					local loc = navic.get_location()
					if loc == '' then
						return ''
					end
					return loc
				end,
				cond = function()
					return true
				end,
				draw_empty = true,
			},
		},
	},
	inactive_winbar = {
		lualine_c = {
			{
				function()
					if not navic.is_available() then
						return ''
					end

					local loc = navic.get_location()
					if loc == '' then
						return ''
					end
					return loc
				end,
				cond = function()
					return true
				end,
				draw_empty = true,
			},
		},
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { { 'filename', file_status = true, path = 1 } },
		lualine_x = {
			'encoding',
			'fileformat',
			'filetype',
		},
		lualine_y = { 'progress' },
		lualine_z = { 'location' },
	},
	inactive_sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = {
			{ 'filename', file_status = true, path = 1 },
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
	extensions = { 'fugitive' },
})
