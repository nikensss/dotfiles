local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazy').setup({
	{
		'nvim-telescope/telescope.nvim',
		branch = 'master',
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	},
	{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme('tokyonight-night')
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdateSync',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-context',
			'nvim-treesitter/nvim-treesitter-refactor',
			'nvim-treesitter/nvim-treesitter-textobjects',
			'windwp/nvim-ts-autotag',
		},
	},
	{
		'ThePrimeagen/harpoon',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer', -- source for text in buffer
			'hrsh7th/cmp-path', -- source for file system paths
			'hrsh7th/cmp-cmdline',
			{ 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' }, -- snippet engine
			'saadparwaiz1/cmp_luasnip', -- for autocompletion
			'rafamadriz/friendly-snippets', -- useful snippets
			'onsails/lspkind.nvim', -- vs-code like pictograms
		},
	},
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/nvim-cmp',
			{
				'antosha417/nvim-lsp-file-operations',
				dependencies = {
					'nvim-lua/plenary.nvim',
				},
				config = function()
					require('lsp-file-operations').setup()
				end,
			},
			{
				'lvimuser/lsp-inlayhints.nvim',
				opts = {},
			},
			{
				'SmiteshP/nvim-navbuddy',
				dependencies = {
					'SmiteshP/nvim-navic',
					'MunifTanjim/nui.nvim',
				},
				opts = { lsp = { auto_attach = true } },
				keys = {
					{
						'<leader>nb',
						function()
							require('nvim-navbuddy').open()
						end,
						desc = 'Open NavBuddy',
					},
				},
			},
		},
	},
	{
		'williamboman/mason.nvim',
		dependencies = {
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
		},
	},
	{
		'stevearc/conform.nvim',
		lazy = true,
		event = { 'BufReadPre', 'BufNewFile' },
	},
	{
		'mfussenegger/nvim-lint',
		lazy = true,
		event = { 'BufReadPre', 'BufNewFile' },
	},
	'lewis6991/gitsigns.nvim',
	'christoomey/vim-sort-motion',
	{ 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
	'nvim-lualine/lualine.nvim',
	'smoka7/hop.nvim',
	'rhysd/git-messenger.vim',
	'tpope/vim-fugitive',
	'tpope/vim-commentary',
	'tpope/vim-repeat',
	'tpope/vim-unimpaired',
	{
		'kylechui/nvim-surround',
		version = '*', -- Use for stability; omit to use `main` branch for the latest features
		event = 'VeryLazy',
		config = function()
			require('nvim-surround').setup({
				aliases = {
					['t'] = '`',
				},
			})
		end,
	},
	'mfussenegger/nvim-dap',
	'nvim-telescope/telescope-dap.nvim',
	'rcarriga/nvim-dap-ui',
	'theHamsta/nvim-dap-virtual-text',
	'folke/neodev.nvim',
	{
		'nvim-neotest/neotest',
		dependencies = {
			'nvim-neotest/nvim-nio',
			'nvim-treesitter/nvim-treesitter',
			'nvim-lua/plenary.nvim',
			'antoinemadec/FixCursorHold.nvim',
			'nvim-neotest/neotest-plenary',
			'nvim-neotest/neotest-vim-test',
			'nvim-neotest/neotest-jest',
			'nvim-neotest/neotest-go',
		},
	},
	'jiangmiao/auto-pairs',
	{
		'catppuccin/nvim',
		name = 'catppuccin',
	},
	'github/copilot.vim',
	'shime/vim-livedown',
	{
		'cameron-wags/rainbow_csv.nvim',
		config = true,
		ft = {
			'csv',
			'tsv',
			'csv_semicolon',
			'csv_whitespace',
			'csv_pipe',
			'rfc_csv',
			'rfc_semicolon',
		},
		cmd = {
			'RainbowDelim',
			'RainbowDelimSimple',
			'RainbowDelimQuoted',
			'RainbowMultiDelim',
		},
	},
	'numToStr/FTerm.nvim',
	{
		'pmizio/typescript-tools.nvim',
		dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
		opts = {},
	},
	{
		'rest-nvim/rest.nvim',
		keys = { '<leader>rr', '<leader>rp', '<leader>rl' },
		dependencies = { 'nvim-lua/plenary.nvim' },
		ft = { 'http' },
		config = function()
			require('rest-nvim').setup({
				-- Open request results in a horizontal split
				result_split_horizontal = false,
				-- Keep the http file buffer above|left when split horizontal|vertical
				result_split_in_place = true,
				-- Skip SSL verification, useful for unknown certificates
				skip_ssl_verification = false,
				-- Encode URL before making request
				encode_url = true,
				-- Highlight request on run
				highlight = {
					enabled = true,
					timeout = 150,
				},
				result = {
					-- toggle showing URL, HTTP info, headers at top the of result window
					show_url = true,
					-- show the generated curl command in case you want to launch
					-- the same request via the terminal (can be verbose)
					show_curl_command = true,
					show_http_info = true,
					show_headers = true,
					-- executables or functions for formatting response body [optional]
					-- set them to false if you want to disable them
					formatters = {
						json = 'jq',
						html = function(body)
							return vim.fn.system({ 'tidy', '-i', '-q', '-' }, body)
						end,
					},
				},
				-- Jump to request line on run
				jump_to_request = false,
				env_file = '.env',
				custom_dynamic_variables = {},
				yank_dry_run = true,
			})

			vim.keymap.set(
				'n',
				'<leader>rr',
				'<Plug>RestNvim',
				{ desc = '[rest.nvim] send request under cursor', silent = true }
			)
			vim.keymap.set(
				'n',
				'<leader>rp',
				'<Plug>RestNvimPreview',
				{ desc = '[rest.nvim] show request preview', silent = true }
			)
			vim.keymap.set(
				'n',
				'<leader>rl',
				'<Plug>RestNvimLast',
				{ desc = '[rest.nvim] send last request', silent = true }
			)
		end,
	},
	{
		'kristijanhusak/vim-dadbod-ui',
		dependencies = {
			'tpope/vim-dadbod',
			{ 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
		},
		cmd = {
			'DBUI',
			'DBUIToggle',
			'DBUIAddConnection',
			'DBUIFindBuffer',
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{
		'folke/zen-mode.nvim',
		dependencies = {
			'folke/twilight.nvim',
		},
		opts = {
			window = {
				width = 180,
			},
		},
	},
	{
		'mbbill/undotree',
		keys = { '<leader>ut' },
		config = function()
			local options = { silent = true, noremap = true, desc = '[undotree] toggle undotree' }
			vim.keymap.set('n', '<leader>ut', '<cmd>UndotreeToggle<cr>', options)
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	},
	{
		'aznhe21/actions-preview.nvim',
		config = function()
			vim.keymap.set({ 'v', 'n' }, 'gf', require('actions-preview').code_actions)
		end,
	},
	{
		'stevearc/dressing.nvim',
		opts = {},
	},
	{
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
	},
	{
		'folke/trouble.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {},
		config = function()
			vim.keymap.set('n', '<leader>ee', function()
				require('trouble').toggle()
			end, { desc = '[trouble] toggle' })

			vim.keymap.set('n', '<leader>ew', function()
				require('trouble').toggle('workspace_diagnostics')
			end, { desc = '[trouble] toggle workspace diagnostics' })

			vim.keymap.set('n', '<leader>ed', function()
				require('trouble').toggle('document_diagnostics')
			end, { desc = '[trouble] toggle document diagnostics' })

			vim.keymap.set('n', '<leader>eq', function()
				require('trouble').toggle('quickfix')
			end, { desc = '[trouble] toggle quickfix' })

			vim.keymap.set('n', '<leader>el', function()
				require('trouble').toggle('loclist')
			end, { desc = '[trouble] toggle loclist' })

			vim.keymap.set('n', '[x', function()
				require('trouble').previous({ skip_groups = true, jump = true })
			end, { desc = '[trouble] previous diagnostic' })

			vim.keymap.set('n', ']x', function()
				require('trouble').next({ skip_groups = true, jump = true })
			end, { desc = '[trouble] next diagnostic' })
		end,
	},
	{
		'mrcjkb/rustaceanvim',
		version = '^4', -- Recommended
		ft = { 'rust' },
		dependencies = {
			'lvimuser/lsp-inlayhints.nvim',
			'nvim-lua/plenary.nvim',
			'mfussenegger/nvim-dap',
		},
	},
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	{
		'SmiteshP/nvim-navic',
		requires = 'neovim/nvim-lspconfig',
		config = function()
			require('nvim-navic').setup()
		end,
	},
	{
		'olrtg/nvim-emmet',
		config = function()
			vim.keymap.set({ 'n', 'v' }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
		end,
	},
	{
		'ray-x/go.nvim',
		dependencies = { -- optional packages
			'ray-x/guihua.lua',
			'neovim/nvim-lspconfig',
			'nvim-treesitter/nvim-treesitter',
			'leoluz/nvim-dap-go',
		},
		config = function()
			require('go').setup({
				dap_debug_keymap = false,
			})
		end,
		event = { 'CmdlineEnter' },
		ft = { 'go', 'gomod' },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
	{
		'rmagatti/goto-preview',
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
	},
	{
		'LukasPietzschmann/telescope-tabs',
		config = function()
			require('telescope').load_extension('telescope-tabs')

			vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

			require('telescope-tabs').setup({
				entry_formatter = function(tab_id, _, _, _, is_current)
					local tab_name = require('tabby.feature.tab_name').get(tab_id)
					return string.format('%d: %s%s', tab_id, tab_name, is_current and ' <' or '')
				end,
				entry_ordinal = function(tab_id)
					return require('tabby.feature.tab_name').get(tab_id)
				end,
			})

			require('tabby.tabline').use_preset('tab_only')
			vim.keymap.set('n', '<leader>tr', [[ :TabRename ]])
		end,
		dependencies = { 'nvim-telescope/telescope.nvim', 'nanozuki/tabby.nvim' },
	},
	{
		'nvim-tree/nvim-tree.lua',
		config = function()
			require('nvim-tree').setup({
				hijack_netrw = true,
			})
		end,
	},
	'segeljakt/vim-silicon',
	'sindrets/diffview.nvim',
	'gleam-lang/gleam.vim',
	'zig.vim',
})
