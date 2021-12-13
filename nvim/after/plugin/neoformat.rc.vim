augroup NeoformatAutoFormat
    autocmd!
    autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx setlocal formatprg=prettier\
                \--stdin
    autocmd BufWritePre * Neoformat
augroup END

nnoremap <leader>p :Neoformat<cr>:w<cr>
let g:neoformat_try_formatprg=1
" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

" use the formate in node_modules
let g:neoformat_try_node_exe = 1
