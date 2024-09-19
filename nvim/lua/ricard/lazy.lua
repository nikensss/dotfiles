local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
		config = function()
			vim.keymap.set('n', '<leader>fq', '<cmd>NvimTreeClose<cr>', { desc = '[nvim-tree] close', silent = true })
		end,
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
			{
				'folke/neoconf.nvim',
				config = function()
					require('neoconf').setup()
				end,
			},
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
	{
		'lewis6991/gitsigns.nvim',
	},
	{
		'christoomey/vim-sort-motion',
	},
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		opts = {},
	},
	{
		'nvim-lualine/lualine.nvim',
	},
	{
		'smoka7/hop.nvim',
	},
	{
		'rhysd/git-messenger.vim',
	},
	{
		'tpope/vim-fugitive',
	},
	{
		'tpope/vim-commentary',
	},
	{
		'tpope/vim-repeat',
	},
	{
		'tpope/vim-unimpaired',
	},
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
	{
		'mfussenegger/nvim-dap',
	},
	{
		'nvim-telescope/telescope-dap.nvim',
	},
	{
		'rcarriga/nvim-dap-ui',
	},
	{
		'theHamsta/nvim-dap-virtual-text',
	},
	{
		'mxsdev/nvim-dap-vscode-js',
		dependencies = { 'mfussenegger/nvim-dap' },
	},
	{
		'folke/lazydev.nvim',
		ft = 'lua', -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
			},
		},
		dependencies = {

			{ 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
			{ -- optional completion source for require statements and module annotations
				'hrsh7th/nvim-cmp',
				opts = function(_, opts)
					opts.sources = opts.sources or {}
					table.insert(opts.sources, {
						name = 'lazydev',
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					})
				end,
			},
		},
	},
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
	{
		'jiangmiao/auto-pairs',
	},
	{
		'catppuccin/nvim',
		name = 'catppuccin',
	},
	{
		'github/copilot.vim',
	},
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
	{
		'numToStr/FTerm.nvim',
	},
	{
		'pmizio/typescript-tools.nvim',
		dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
	},
	{
		'vhyrro/luarocks.nvim',
		config = true,
		priority = 1000,
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
				require('trouble').toggle('diagnostics')
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
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v3.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
			'MunifTanjim/nui.nvim',
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		opts = {
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				hijack_netrw_behavior = 'disabled',
			},
			window = {
				position = 'float',
			},
		},
	},
	{
		'segeljakt/vim-silicon',
	},
	{
		'sindrets/diffview.nvim',
		config = function()
			local actions = require('diffview.actions')

			require('diffview').setup({
				keymaps = {
					file_panel = {
						['<tab>'] = false,
						['<s-tab>'] = false,
						{
							'n',
							'<c-n>',
							actions.select_next_entry,
							{ desc = 'Open the diff for the next file' },
						},
						{
							'n',
							'<c-p>',
							actions.select_prev_entry,
							{ desc = 'Open the diff for the previous file' },
						},
					},
				},
			})
		end,
	},
	{
		'ziglang/zig.vim',
	},
	{
		'pwntester/octo.nvim',
		config = function()
			require('octo').setup({ enable_builtin = true })
		end,
		keys = {
			{ '<leader>o', '<cmd>Octo<CR>', desc = 'Octo' },
		},
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
			'nvim-tree/nvim-web-devicons',
		},
	},
	{
		'sigmasd/deno-nvim',
	},
	{
		'kndndrj/nvim-dbee',
		dependencies = {
			'MunifTanjim/nui.nvim',
		},
		build = function()
			require('dbee').install()
		end,
		config = function()
			require('dbee').setup({
				sources = {
					require('dbee.sources').EnvSource:new('DBEE_CONNECTIONS'),
				},
				result = {
					page_size = 100000,
				},
			})
		end,
		keys = {
			{ '<leader><leader>pg', '<cmd>lua require"dbee".toggle()<CR>', desc = '[dbee] toggle' },
		},
	},
	{
		'elixir-tools/elixir-tools.nvim',
		version = '*',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			require('elixir').setup()
		end,
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	},
	{
		'windwp/nvim-ts-autotag',
		config = function()
			require('nvim-ts-autotag').setup()
		end,
	},
	{
		'rest-nvim/rest.nvim',
	},
	{
		'OXY2DEV/markview.nvim',
		lazy = false, -- Recommended
		-- ft = "markdown" -- If you decide to lazy-load anyway

		dependencies = {
			-- You will not need this if you installed the
			-- parsers manually
			-- Or if the parsers are in your $RUNTIMEPATH
			'nvim-treesitter/nvim-treesitter',

			'nvim-tree/nvim-web-devicons',
		},
	},
})
