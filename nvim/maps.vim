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

" Delete a word backwards
nnoremap dw vb"_d

" Select all
nmap <C-a> gg<S-v>G

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

"-----------------------------
" Tabs

" Open current directory
nmap te :tabedit 
nmap <S-Tab> :tabprev<Return>
nmap <Tab> :tabnext<Return>

"------------------------------
" Windows

" Split window
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w
" Move window
nmap <leader><leader> <C-w>w
map s<left> <C-w>h
map s<up> <C-w>k
map s<down> <C-w>j
map s<right> <C-w>l
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l
map sq <C-w>q

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

" Moving text
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv
inoremap <C-j> <esc>:m .+1<cr>==
inoremap <C-k> <esc>:m .-2<cr>==
nnoremap <leader>j :m .+1<cr>==
nnoremap <leader>k :m .-2<cr>==

