local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.level=ALL",
		"-Xms1g",
		"-jar",
		vim.fn.expand("~/repos/java/jdtls-160/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar"),
		"-configuration",
		vim.fn.expand("~/repos/java/jdtls-160/config_mac/"),
		"-data",
		vim.fn.expand("~/.cache/jdtls-workspace/") .. project_name,
	},
	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
	capabilities = capabilities,
}
require("jdtls").start_or_attach(config)

vim.api.nvim_set_keymap("n", "<leader>lA", "<cmd>lua require('jdtls').code_actions()<CR>", { silent = true })

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>zz", opts)
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>zz", opts)
vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>zz", opts)
vim.api.nvim_set_keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
