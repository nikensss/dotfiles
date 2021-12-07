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
nnoremap <leader>qJ :cfirst<CR>zz
nnoremap <leader>qk :cprevious<CR>zz
nnoremap <leader>qK :clast<CR>zz

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
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w
" Go to definition in side window
nmap sd svgd
" Swap between windows
nmap <leader><leader> <C-w>w
" Move window
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l
" Close last used window
map sp <C-w>p<C-w>q
" Close window
map sq <C-w>q
" Close other windows
map so <C-w>o

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

" Yank to the end of the line
nnoremap Y y$

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
