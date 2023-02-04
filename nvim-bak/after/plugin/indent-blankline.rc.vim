
let g:indent_blankline_use_treesitter = v:true

lua << EOF
require("indent_blankline").setup {
    char = "|",
    buftype_exclude = {"terminal"}
}
EOF
