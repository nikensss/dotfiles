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
		'L3MON4D3/LuaSnip',
		dependencies = { 'rafamadriz/friendly-snippets' },
	},
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-buffer', -- source for text in buffer
			'hrsh7th/cmp-path', -- source for file system paths
			'L3MON4D3/LuaSnip', -- snippet engine
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
			{ 'antosha417/nvim-lsp-file-operations', config = true },
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
			vim.g.blamer_enabled = 1
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
	'tpope/vim-surround',
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
	{ 'catppuccin/nvim', name = 'catppuccin' },
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
		'nvimdev/lspsaga.nvim',
		config = function() end,
		dependencies = {
			'nvim-treesitter/nvim-treesitter', -- optional
			'nvim-tree/nvim-web-devicons', -- optional
		},
	},
	{ 'rest-nvim/rest.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
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
})
