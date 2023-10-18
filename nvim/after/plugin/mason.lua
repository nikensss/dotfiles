local mason = require('mason')

-- import mason-lspconfig
local mason_lspconfig = require('mason-lspconfig')

local mason_tool_installer = require('mason-tool-installer')

-- enable mason and configure icons
mason.setup({
	ui = {
		icons = {
			package_installed = '✓',
			package_pending = '➜',
			package_uninstalled = '✗',
		},
	},
})

mason_lspconfig.setup({
	-- list of servers for mason to install
	ensure_installed = {
		'bashls',
		'cssls',
		'graphql',
		'html',
		'lua_ls',
		'prismals',
		'pyright',
		'rust_analyzer',
		'sqlls',
		'tailwindcss',
		-- 'tsserver',
	},
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
})

mason_tool_installer.setup({
	ensure_installed = {
		'black', -- python formatter
		'eslint_d', -- js linter
		'isort', -- python formatter
		'prettier', -- prettier formatter
		'pylint', -- python linter
		'stylua', -- lua formatter
		'sql-formatter', -- sql formatter
	},
})
