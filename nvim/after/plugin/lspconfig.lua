--vim.lsp.set_log_level("debug")

vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>zz")
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>zz")
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>zz")
vim.keymap.set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "<leader>e", "<cmd>lua vim.lsp.diagnostics.show_line_diagnostics()<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>lua vim.lsp.diagnostics.set_loclist()<CR>")

require("mason").setup()
require("mason-lspconfig").setup()

local nvim_lsp = require("lspconfig")
local protocol = require("vim.lsp.protocol")
protocol.CompletionItemKind = {
	"", -- Text
	"", -- Method
	"", -- Function
	"", -- Constructor
	"", -- Field
	"", -- Variable
	"", -- Class
	"ﰮ", -- Interface
	"", -- Module
	"", -- Property
	"", -- Unit
	"", -- Value
	"", -- Enum
	"", -- Keyword
	"﬌", -- Snippet
	"", -- Color
	"", -- File
	"", -- Reference
	"", -- Folder
	"", -- EnumMember
	"", -- Constant
	"", -- Struct
	"", -- Event
	"ﬦ", -- Operator
	"", -- TypeParameter
}

local function lspSymbol(name, icon)
	vim.fn.sign_define("DiagnosticSign" .. name, { text = icon, numhl = "DiagnosticDefault" .. name })
end
lspSymbol("Error", "")
lspSymbol("Information", "")
lspSymbol("Hint", "")
lspSymbol("Info", "")
lspSymbol("Warning", "")

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local ts_utils = require("nvim-lsp-ts-utils")

	ts_utils.setup({
		debug = false,
		disable_commands = false,
		enable_import_on_completion = false,

		-- import all
		import_all_timeout = 5000, -- ms
		-- lower numbers = higher priority
		import_all_priorities = {
			same_file = 1, -- add to existing import statement
			local_files = 2, -- git files or files with relative path markers
			buffer_content = 3, -- loaded buffer content
			buffers = 4, -- loaded buffer names
		},
		import_all_scan_buffers = 100,
		import_all_select_source = false,
		-- if false will avoid organizing imports
		always_organize_imports = true,

		-- filter diagnostics
		filter_out_diagnostics_by_severity = {},
		filter_out_diagnostics_by_code = {},

		-- inlay hints
		auto_inlay_hints = false,
		inlay_hints_highlight = "Comment",
		inlay_hints_priority = 200, -- priority of the hint extmarks
		inlay_hints_throttle = 150, -- throttle the inlay hint request
		inlay_hints_format = { -- format options for individual hint kind
			Type = {},
			Parameter = {},
			Enum = {},
			-- Example format customization for `Type` kind:
			-- Type = {
			--     highlight = "Comment",
			--     text = function(text)
			--         return "->" .. text:sub(2)
			--     end,
			-- },
		},

		-- update imports on file move
		update_imports_on_move = false,
		require_confirmation_on_move = false,
		watch_dir = nil,
	})

	-- required to fix code action ranges and filter diagnostics
	ts_utils.setup_client(client)

	-- no default maps, so you may want to define some here
	local opts = { silent = true }
	buf_set_keymap("n", "<leader>oi", ":TSLspOrganize<CR>", opts)
	buf_set_keymap("n", "<leader>rf", ":TSLspRenameFile<CR>", opts)
	buf_set_keymap("n", "<leader>ia", ":TSLspImportAll<CR>", opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.astro.setup({})

nvim_lsp.tsserver.setup({
	init_options = require("nvim-lsp-ts-utils").init_options,
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.diagnosticls.setup({
	on_attach = on_attach,
	filetypes = {
		"javascript",
		"javascriptreact",
		"json",
		"typescript",
		"typescriptreact",
		"css",
		"less",
		"scss",
		"markdown",
		"pandoc",
	},
	init_options = {
		linters = {
			eslint = {
				command = "eslint_d",
				rootPatterns = { ".eslintrc.json" },
				debounce = 100,
				args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
				sourceName = "eslint_d",
				parseJson = {
					errorsRoot = "[0].messages",
					line = "line",
					column = "column",
					endLine = "endLine",
					endColumn = "endColumn",
					message = "[eslint] ${message} [${ruleId}]",
					security = "severity",
				},
				securities = {
					[2] = "error",
					[1] = "warning",
				},
			},
		},
		filetypes = {
			javascript = "eslint",
			javascriptreact = "eslint",
			typescript = "eslint",
			typescriptreact = "eslint",
		},
	},
})

nvim_lsp.pyright.setup({})

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	-- This sets the spacing and the prefix, obviously.
	virtual_text = {
		spacing = 4,
		prefix = "",
	},
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
local liblldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
if vim.fn.has("mac") == 1 then
	liblldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.dylib"
end

local rt = require("rust-tools")
local rust_opts = {
	tools = {
		hover_actions = {
			auto_focus = true,
		},
	},
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<Leader>ca", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>ga", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
		settings = {
			-- to enable rust-analyzer settings visit:
			-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
			["rust-analyzer"] = {
				-- enable clippy on save
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
}

rt.setup(rust_opts)

nvim_lsp.bash.setup({})
