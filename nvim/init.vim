" Fundamentals 
" ---------------------------------------------------------------------

" init autocmd
autocmd!
" set script encoding
scriptencoding utf-8
" stop loading config if it's on tiny or small
if !1 | finish | endif

set nocompatible
set nolist
set rnu
set modelines=0
set number
syntax enable
set fileencodings=utf-8,sjis,euc-jp,latin
set encoding=utf-8
set title
set autoindent
set background=dark
set nobackup
set nowritebackup
set showcmd
set cmdheight=2
set laststatus=2
set scrolloff=5
set colorcolumn=80,100,120
set expandtab
set clipboard+=unnamedplus
"let loaded_matchparen = 1
set shell=zsh
set backupskip=/tmp/*,/private/tmp/*

set textwidth=79
set tabstop=2
set softtabstop=2
set nohlsearch
set noerrorbells
set hidden

set matchpairs+=<:>

" Helps force plug-ins to load correctly when it is turned back on below.
filetype off
" For plug-ins to load correctly.
filetype plugin indent on

" incremental substitution (neovim)
if has('nvim')
  set inccommand=split
endif

" Suppress appending <PasteStart> and <PasteEnd> when pasting
set t_BE=

set nosc noru nosm
" Don't redraw while executing macros (good performance config)
set lazyredraw
"set showmatch
" How many tenths of a second to blink when matching brackets
"set mat=2
" Ignore case when searching
set ignorecase
" Be smart when using tabs ;)
set smarttab
" indents
filetype plugin indent on
set shiftwidth=2
set tabstop=2
set ai "Auto indent
set si "Smart indent
set nowrap "No Wrap lines
set formatoptions-=t "do not automatically wrap text when typing
set backspace=start,eol,indent
" Finding files - Search down into subfolders
set path+=**
set wildignore+=*/node_modules/*
set wildignore+=*/venv/**/*

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

" Add asterisks in block comments
set formatoptions+=r

" Highlights 
" ---------------------------------------------------------------------
set cursorline
"set cursorcolumn

" Set cursor line color on visual mode
highlight Visual cterm=NONE ctermbg=236 ctermfg=NONE guibg=Grey40

highlight LineNr cterm=none ctermfg=240 guifg=#2b506e guibg=#000000

augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

if &term =~ "screen"
  autocmd BufEnter * if bufname("") !~ "^?[A-Za-z0-9?]*://" | silent! exe '!echo -n "\ek[`hostname`:`basename $PWD`/`basename %`]\e\\"' | endif
  autocmd VimLeave * silent!  exe '!echo -n "\ek[`hostname`:`basename $PWD`]\e\\"'
endif


" File types 
" JavaScript
au BufNewFile,BufRead *.es6 setf javascript
" TypeScript
au BufNewFile,BufRead *.tsx setf typescriptreact
" Markdown
au BufNewFile,BufRead *.md set filetype=markdown

set suffixesadd=.js,.es,.jsx,.json,.css,.less,.sass,.styl,.php,.py,.md

autocmd FileType coffee setlocal shiftwidth=2 tabstop=2
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

" Imports 
" ---------------------------------------------------------------------
runtime ./plug.vim
if has("unix")
  let s:uname = system("uname -s")
  " Do Mac stuff
  if s:uname == "Darwin\n"
    runtime ./macos.vim
  endif
endif

runtime ./maps.vim

" Syntax theme 
" ---------------------------------------------------------------------

" true color
if exists("&termguicolors") && exists("&winblend")
  syntax enable
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
  set background=dark
  " Use onedark
  let g:onedark_style = 'darker'
  colorscheme onedark
endif

" Extras 
" ---------------------------------------------------------------------
set exrc


let g:markdown_fenced_languages = ["html","css","scss","javascript","js=javascript","json=javascript","typescript","ts=typescript","bash","bash=sh"]
" Remove elements from quickfix list
nnoremap <buffer> <silent> dd
  \ <Cmd>call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r') <Bar><CR>
