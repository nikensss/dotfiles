local keymap = vim.keymap.set
local saga = require("lspsaga")

saga.setup({
	ui = {
		border = "rounded",
	},
	request_timeout = 15000,
	finder = {
		vsplit = "<C-v>",
		split = "<C-s>",
	},
})

keymap("n", "]a", "<cmd>Lspsaga diagnostic_jump_next<CR>zz", { silent = true })
keymap("n", "[a", "<cmd>Lspsaga diagnostic_jump_prev<CR>zz", { silent = true })
keymap("n", "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<CR>zz", { silent = true })
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
keymap("n", "ga", "<cmd>Lspsaga code_action<CR>", { silent = true })
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
keymap("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
