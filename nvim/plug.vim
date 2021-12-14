if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'AndrewRadev/sideways.vim'
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-sort-motion'
Plug 'cohama/lexima.vim'
Plug 'junegunn/gv.vim'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'mattn/emmet-vim'
Plug 'navarasu/onedark.nvim'
Plug 'preservim/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'shime/vim-livedown'
Plug 'szw/vim-maximizer'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

if has("nvim")
  Plug 'mfussenegger/nvim-jdtls'
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'SirVer/ultisnips'
  Plug 'folke/lsp-colors.nvim'
  Plug 'honza/vim-snippets'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'kristijanhusak/defx-git'
  Plug 'kristijanhusak/defx-icons'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'phaazon/hop.nvim'
  Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'sbdchd/neoformat'
  Plug 'simrat39/rust-tools.nvim'
  Plug 'tami5/lspsaga.nvim'
endif

call plug#end()

