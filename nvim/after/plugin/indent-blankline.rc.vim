highlight IndentBlanklineChar guibg=#444444 gui=nocombine
highlight IndentBlanklineSpaceChar guibg=#444444 gui=nocombine
highlight IndentBlanklineSpaceCharBlankline guibg=#444444 gui=nocombine

let g:indent_blankline_use_treesitter = v:true

lua << EOF
require("indent_blankline").setup {
    char = "|",
    buftype_exclude = {"terminal"}
}
EOF
