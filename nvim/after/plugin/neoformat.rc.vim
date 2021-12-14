augroup NeoformatAutoFormat
    autocmd!
    autocmd FileType java,javascript,javascript.jsx,typescript,typescript.tsx setlocal formatprg=prettier\
                \--stdin
    autocmd BufWritePre * Neoformat
augroup END

nnoremap <leader>p :Neoformat<cr>:w<cr>
let g:neoformat_try_formatprg=1
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

" use the formate in node_modules
let g:neoformat_try_node_exe = 1
