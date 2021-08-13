let g:neoformat_try_formatprg=1

autocmd BufWritePre,InsertLeave * Neoformat

augroup NeoformatAutoFormat
    autocmd!
    autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx setlocal formatprg=prettier\
                \--stdin
    autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx Neoformat
augroup END

nnoremap <leader>p :Neoformat<cr>:w<cr>
