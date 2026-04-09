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
		'clangd',
		'cssls',
		'emmet_language_server',
		'graphql',
		'html',
		'jsonls',
		'lua_ls',
		'prismals',
		'tailwindcss',
		'taplo',
		'zls',
		-- 'codelldb',
	},
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
})

mason_tool_installer.setup({
	ensure_installed = {
		'biome', -- biome formatter/linter (used when biome.json is present)
		'clang-format', -- c/c++ formatter
		'eslint_d', -- fast eslint daemon (used by nvim-lint)
		'prettier', -- prettier formatter
		'stylua', -- lua formatter
	},
})
