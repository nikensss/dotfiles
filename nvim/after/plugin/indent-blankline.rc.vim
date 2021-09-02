lua << EOF
require("indent_blankline").setup {
    char = "|",
    buftype_exclude = {"terminal"}
}
EOF
