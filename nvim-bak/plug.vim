if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

if has("nvim")
  Plug 'APZelos/blamer.nvim'
  Plug 'AndrewRadev/sideways.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'catppuccin/nvim', {'as': 'catppuccin'}
  Plug 'christoomey/vim-sort-motion'
  Plug 'cohama/lexima.vim'
  Plug 'cuducos/yaml.nvim'
  Plug 'folke/lsp-colors.nvim'
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'folke/trouble.nvim'
  Plug 'ggandor/leap.nvim'
  Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
  Plug 'honza/vim-snippets'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-nvim-lua'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
  Plug 'junegunn/gv.vim'
  Plug 'kana/vim-textobj-indent'
  Plug 'kana/vim-textobj-user'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'mattn/emmet-vim'
  Plug 'mbbill/undotree'
  Plug 'mfussenegger/nvim-jdtls'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'navarasu/onedark.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
  Plug 'nvim-telescope/telescope-ui-select.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-treesitter/nvim-treesitter-context'
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'pantharshit00/vim-prisma'
  Plug 'phaazon/hop.nvim'
  Plug 'preservim/nerdtree'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'rhysd/git-messenger.vim'
  Plug 'rust-lang/rust.vim'
  Plug 'sbdchd/neoformat'
  Plug 'sheerun/vim-polyglot'
  Plug 'shime/vim-livedown'
  Plug 'simrat39/rust-tools.nvim'
  Plug 'szw/vim-maximizer'
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'tree-sitter/tree-sitter-python'

  " debugging
  Plug 'David-Kunz/jester'
  Plug 'mfussenegger/nvim-dap'
  Plug 'nvim-telescope/telescope-dap.nvim'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'theHamsta/nvim-dap-virtual-text'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'williamboman/mason.nvim'
endif

call plug#end()

