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

keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
