
autocmd BufWritePre,InsertLeave *.{js,jsx,ts,tsx} Neoformat

let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_typescript = ['prettier']
