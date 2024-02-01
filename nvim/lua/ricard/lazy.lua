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
		},
	},
	{
		'ThePrimeagen/harpoon',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	},
	'tpope/vim-fugitive',
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
					'nvim-neo-tree/neo-tree.nvim',
				},
				config = function()
					require('lsp-file-operations').setup()
				end,
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
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v2.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
			'MunifTanjim/nui.nvim',
		},
	},
	{
		'APZelos/blamer.nvim',
		init = function()
			vim.g.blamer_enabled = 0
			vim.g.blamer_delay = 700
			vim.g.blamer_show_in_insert_modes = 1
			vim.g.blamer_show_in_visual_modes = 0
		end,
	},
	'airblade/vim-gitgutter',
	'christoomey/vim-sort-motion',
	'junegunn/gv.vim',
	{ 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
	'mg979/vim-visual-multi',
	'nvim-lualine/lualine.nvim',
	'phaazon/hop.nvim',
	'rhysd/git-messenger.vim',
	'tpope/vim-abolish',
	'tpope/vim-commentary',
	'tpope/vim-repeat',
	{
		'kylechui/nvim-surround',
		version = '*', -- Use for stability; omit to use `main` branch for the latest features
		event = 'VeryLazy',
		config = function()
			require('nvim-surround').setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	'tpope/vim-unimpaired',
	'mfussenegger/nvim-dap',
	'nvim-telescope/telescope-dap.nvim',
	'rcarriga/nvim-dap-ui',
	'theHamsta/nvim-dap-virtual-text',
	'folke/neodev.nvim',
	{
		'nvim-neotest/neotest',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'antoinemadec/FixCursorHold.nvim',
			'nvim-neotest/neotest-plenary',
			'nvim-neotest/neotest-vim-test',
			'nvim-neotest/neotest-jest',
			'rouge8/neotest-rust',
		},
	},
	'jiangmiao/auto-pairs',
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v2.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'MunifTanjim/nui.nvim',
		},
		opts = {
			filesystem = {
				follow_current_file = true,
				hijack_netrw_behavior = 'open_current',
			},
		},
	},
	{
		'simrat39/rust-tools.nvim',
		dependencies = {
			'neovim/nvim-lspconfig',
			'nvim-lua/plenary.nvim',
			'mfussenegger/nvim-dap',
		},
	},
	'mattn/emmet-vim',
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
	'folke/twilight.nvim',
	{
		'folke/zen-mode.nvim',
		opts = {
			window = {
				width = 180,
			},
		},
	},
	'ThePrimeagen/git-worktree.nvim',
	{
		'Wansmer/treesj',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		keys = { '<leader>mm' },
		config = function()
			require('treesj').setup({
				use_default_keymaps = false,
			})

			vim.keymap.set(
				'n',
				'<leader>mm',
				require('treesj').toggle,
				{ silent = true, noremap = true, desc = '[treesj] toogle one-lining' }
			)
		end,
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
	-- lazy.nvim
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		opts = {},
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
			end)

			vim.keymap.set('n', '<leader>ew', function()
				require('trouble').toggle('workspace_diagnostics')
			end)

			vim.keymap.set('n', '<leader>ed', function()
				require('trouble').toggle('document_diagnostics')
			end)

			vim.keymap.set('n', '<leader>eq', function()
				require('trouble').toggle('quickfix')
			end)

			vim.keymap.set('n', '<leader>el', function()
				require('trouble').toggle('loclist')
			end)

			vim.keymap.set('n', 'gR', function()
				require('trouble').toggle('lsp_references')
			end)
		end,
	},
})
