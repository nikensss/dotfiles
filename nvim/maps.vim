" Description: Keymaps

let mapleader = " "
nnoremap <leader>w :w<cr>

nnoremap <S-C-p> "0p
" Delete without yank
nnoremap <leader>d "_d
nnoremap x "_x

" Increment/decrement
nnoremap + <C-a>
nnoremap - <C-x>

" Select all
nmap <C-a> gg<S-v>Gygv

" Quickfix list mappings
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>
nnoremap <leader>qj :cnext<CR>zz
nnoremap <leader>qJ :clast<CR>zz
nnoremap <leader>qk :cprevious<CR>zz
nnoremap <leader>qK :cfirst<CR>zz

" Location list mappings
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>lc :lclose<CR>
nnoremap <leader>lj :lnext<CR>zz
nnoremap <leader>lJ :lfirst<CR>zz
nnoremap <leader>lk :lprevious<CR>zz
nnoremap <leader>lK :llast<CR>zz

" Autoclose tags
inoremap <buffer> <C-t> <esc>yiwi<lt><esc>ea></><esc>hpF>i

" Save with root permission
command! W w !sudo tee > /dev/null %

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>


"------------------------------
" Windows

" Split window
nmap <leader>ss :split<Return><C-w>w
nmap <leader>sv :vsplit<Return><C-w>w
" Go to definition in side window
nmap <leader>sd <leader>svgd
" Swap between windows
nmap <leader><leader> <C-w>w
" Move window
map <leader>sh <C-w>h
map <leader>sk <C-w>k
map <leader>sj <C-w>j
map <leader>sl <C-w>l
" Move to floating window
map <leader>sp <C-w>p
" Close window
map <leader>sq <C-w>q
" Close other windows
map <leader>so <C-w>o
" Leave only diff window open (to be used when only the :Git status window is
" open and the cursor is on the diff window already)
map <leader>od <leader>gs<leader>sq<leader>sl

" Resize window
nmap <C-w><left> <C-w><
nmap <C-w><right> <C-w>>
nmap <C-w><up> <C-w>+
nmap <C-w><down> <C-w>-

nnoremap <leader><cr> :so ~/.config/nvim/init.vim<cr>
nnoremap <leader>pv <c-w>v:Ex<cr>
nnoremap <leader>+ :vertical resize +5<cr>
nnoremap <leader>- :vertical resize -5<cr>
nnoremap <leader>= <c-w>=
nnoremap <leader>rp :vertical resize 120<cr>
nnoremap <leader><up> <C-w>+
nnoremap <leader><leader><up> <C-w>15+
nnoremap <leader><down> <C-w>-
nnoremap <leader><leader><down> <C-w>15-

" Yank to the end of the line
nnoremap Y y$

" Select to the end of the line
nnoremap <leader>v v$

" Keep the cursor centered when joining lines or moving around
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z:delm!<cr>

" Jumplist mutations (jump back points when moving more than 5 lines at a time)
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Wrap variable in interpolated string notation
nmap <leader>ip ysiw`ysi`}i$<esc>f`
vmap <leader>ip S`ysi`}i$<esc>f`

" Select pasted text
nnoremap gp `[v`]

" Remove elements from quickfix list
nnoremap <buffer> <silent> dd
  \ <Cmd>call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r') <Bar><CR>

" Quit vim
nnoremap <leader>qa :qa<CR>

" Take notes
nmap <leader>n<CR> :tab drop notes.md<CR>

" Switch to light themes (it's impossible to work in the office with a dark theme...)
nnoremap <leader><leader>cp :colorscheme PaperColor <BAR> set background=light<CR>
nnoremap <leader><leader>ct :colorscheme tokyonight <BAR> set background=light<CR>
