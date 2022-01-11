if !exists('g:loaded_lspsaga') | finish | endif

lua << EOF
local saga = require 'lspsaga'

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
	max_preview_lines = 25,
	finder_action_keys = {
		vsplit = '<C-v>',
		split = '<C-s>',
	}
}

EOF

nnoremap <silent> ]a <Cmd>Lspsaga diagnostic_jump_next<CR>zz
nnoremap <silent> [a <Cmd>Lspsaga diagnostic_jump_prev<CR>zz
nnoremap <silent> K <Cmd>Lspsaga hover_doc<CR>
inoremap <silent> <C-k> <Cmd>Lspsaga signature_help<CR>
nnoremap <silent> <leader>rn <Cmd>Lspsaga rename<CR>
nnoremap <silent> ga <Cmd>Lspsaga code_action<CR>
nnoremap <silent> gh <Cmd>Lspsaga lsp_finder<CR>
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>

