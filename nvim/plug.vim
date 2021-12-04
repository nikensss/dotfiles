if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'
Plug 'cohama/lexima.vim'
Plug 'navarasu/onedark.nvim'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'szw/vim-maximizer'
Plug 'preservim/nerdtree'
Plug 'shime/vim-livedown'
Plug 'AndrewRadev/sideways.vim'

if has("nvim")
  Plug 'simrat39/rust-tools.nvim'
  Plug 'phaazon/hop.nvim'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'kristijanhusak/defx-git'
  Plug 'kristijanhusak/defx-icons'
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neovim/nvim-lspconfig'
  Plug 'tami5/lspsaga.nvim'
  Plug 'folke/lsp-colors.nvim'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'SirVer/ultisnips'
  Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
  Plug 'sbdchd/neoformat'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'ray-x/lsp_signature.nvim'
endif

call plug#end()

