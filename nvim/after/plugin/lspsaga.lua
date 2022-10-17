local keymap = vim.keymap.set
local saga = require("lspsaga")

saga.init_lsp_saga({
	diagnostic_header = { " ", " ", " ", " " },
	border_style = "rounded",
	max_preview_lines = 25,
	finder_request_timeout = 15000,
	finder_action_keys = {
		vsplit = "<C-v>",
		split = "<C-s>",
	},
})

keymap("n", "]a", "<cmd>Lspsaga diagnostic_jump_next<CR>zz", { silent = true })
keymap("n", "[a", "<cmd>Lspsaga diagnostic_jump_prev<CR>zz", { silent = true })
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
keymap("n", "<C-k>", "<cmd>Lspsaga signature_help<CR>", { silent = true })
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
keymap("n", "ga", "<cmd>Lspsaga code_action<CR>", { silent = true })
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
keymap("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
