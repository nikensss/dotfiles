" Don't try to be vi compatible
set nocompatible
set nolist
set rnu
" Helps force plug-ins to load correctly when it is turned back on below.
filetype off
" Turn on syntax highlighting.
syntax on
" For plug-ins to load correctly.
filetype plugin indent on
" Turn off modelines
set modelines=0
" Do not wrap text that extends beyond the screen length.
set nowrap
" Vim's auto indentation feature does not work properly with text copied from
" outside of Vim. Press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>
set autochdir
" Uncomment below to set the max textwidth. Use a value corresponding to the
" width of your screen.
set textwidth=79
set formatoptions=tcrqn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set smartindent
set relativenumber
set nu
set nohlsearch
set noerrorbells
set hidden
set nobackup
set nowritebackup
set scrolloff=8
set signcolumn=yes
set colorcolumn=80,100,120
set cmdheight=2
set background=dark

" Fixes common backspace problems
set backspace=indent,eol,start
" Speed up scrolling in Vim
set ttyfast
" Status bar
set laststatus=2
" Display options
set showmode
set showcmd
" Highlight matching pairs of brackets. Use the '%' character to jump between
" them.
set matchpairs+=<:>
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}
set encoding=utf-8
" Enable incremental search
set incsearch
" Include matching uppercase words with lowercase search term
set ignorecase
" Include only uppercase words with uppercase search term
set smartcase

" Store info from no more than 100 files at a time, 9999 lines of text, 100kb
" of data. Useful for copying large amounts of data between files.
set viminfo='100,<9999,s100

" Map the <Space> key to toggle a selected fold opened/closed.
nnoremap <silent> <Space>f @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space>f zf

" Automatically save and load folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview"
let mapleader = " "
nnoremap <leader>w :w<cr>
nnoremap <leader>gs :CocSearch 
nnoremap <leader>fs :Files<cr>
nnoremap <leader><cr> <cr><c-w>h:q<cr>
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'

call plug#end()

let g:coc_global_extensions = [ 'coc-tsserver' ]
let g:prettier#config#single_quote = 'true'
let g:prettier#config#trailing_comma = 'none'
let g:airline_powerline_fonts = 1

let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled = 1

" Yank to the end of the line
nnoremap Y y$

" Keep the cursor centered when joining lines or moving around
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Add more checkpoints when undoing changes
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ; ;<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap [ [<c-g>u
inoremap ] ]<c-g>u
inoremap { {<c-g>u
inoremap } }<c-g>u

" Jumplist mutations (jump back points when moving more than 5 lines at a time)
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" Git remaps
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gs :G<CR>

" Prettier remaps
nnoremap <leader>p :Prettier<CR>

" Force max line length in entire file
nnoremap <leader>fa gg V G gq<Esc>

" Easymotion remaps
map <leader>e <Plug>(easymotion-prefix)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
:imap ii <Esc>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Color scheme (terminal)
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
" colorscheme solarized

" Modify cursor style
let &t_SI="\033[4 q" " start insert mode
let &t_EI="\033[1 q" " end insert mode

let g:prettier#autoformat_require_pragma = 0
