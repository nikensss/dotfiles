augroup NeoformatAutoFormat
    autocmd!
    autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx setlocal formatprg=prettier\
                \--stdin
    autocmd BufWritePre * Neoformat
augroup END

nnoremap <leader>p :Neoformat<cr>:w<cr>
let g:neoformat_try_formatprg=1
