-- import lspconfig plugin
require('lspsaga').setup({
	finder = {
		methods = {
			tyd = 'textDocument/typeDefinition',
		},
	},
	outline = {
		close_after_jump = true,
	},
})

-- lsp status report
require('fidget').setup()

local lspconfig = require('lspconfig')
-- import cmp-nvim-lsp plugin
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local keymap = vim.keymap -- for conciseness

local opts = { noremap = true, silent = true }
local on_attach = function(_, bufnr)
	opts.buffer = bufnr

	print('setting Lspsaga keybinds...')

	-- set keybinds
	opts.desc = 'Show LSP references'
	keymap.set('n', 'gr', '<cmd>Lspsaga finder ref+imp+def+tyd<CR>', opts) -- show definition, references

	opts.desc = 'Go to declaration'
	keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- go to declaration

	opts.desc = 'Show LSP definitions'
	keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', opts) -- show lsp definitions
	keymap.set('n', '<C-g><C-d>', '<C-w><C-v><cmd>Lspsaga goto_definition<CR>', opts) -- show lsp definitions

	opts.desc = 'Show LSP type definitions'
	keymap.set('n', 'gy', '<cmd>Lspsaga goto_type_definition<CR>', opts) -- show lsp type definitions

	opts.desc = 'Peek LSP definitions'
	keymap.set('n', '<leader>pd', '<cmd>Lspsaga peek_definition<CR>', opts) -- show lsp definitions

	opts.desc = 'Show LSP type definitions'
	keymap.set('n', '<leader>py', '<cmd>Lspsaga peek_type_definition<CR>', opts) -- show lsp type definitions

	opts.desc = 'Show LSP implementations'
	keymap.set('n', 'gi', '<cmd>Lspsaga finder imp<CR>', opts) -- show lsp implementations

	opts.desc = 'Show outline'
	keymap.set('n', 'go', '<cmd>Lspsaga outline<CR>', opts) -- show outline

	opts.desc = 'Show incoming calls'
	keymap.set('n', 'gj', '<cmd>Lspsaga incoming_calls<CR>', opts) -- show outline

	opts.desc = 'Show outgoing calls'
	keymap.set('n', 'gk', '<cmd>Lspsaga outgoing_calls<CR>', opts) -- show outline

	opts.desc = 'See available code actions'
	keymap.set({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts) -- see available code actions, in visual mode will apply to selection

	opts.desc = 'Smart rename'
	keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', opts) -- smart rename

	opts.desc = 'Show buffer diagnostics'
	keymap.set('n', '<leader>sd', '<cmd>Lspsaga show_buf_diagnostics<CR>', opts) -- show  diagnostics for file

	opts.desc = 'Show line diagnostics'
	keymap.set('n', '<leader>ld', '<cmd>Lspsaga show_line_diagnostics<CR>', opts) -- show diagnostics for line

	opts.desc = 'Go to previous diagnostic'
	keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts) -- jump to previous diagnostic in buffer

	opts.desc = 'Go to next diagnostic'
	keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts) -- jump to next diagnostic in buffer

	opts.desc = 'Show documentation for what is under cursor'
	keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts) -- show documentation for what is under cursor

	opts.desc = 'Signature help'
	keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts) -- show documentation for what is under cursor

	opts.desc = 'Restart LSP'
	keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts) -- mapping to restart lsp if necessary

	print('Lspsaga keybinds set!')
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
for type, icon in pairs(signs) do
	local hl = 'DiagnosticSign' .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

-- configure html server
lspconfig['html'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure css server
lspconfig['cssls'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure prisma orm server
lspconfig['prismals'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure graphql language server
lspconfig['graphql'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { 'graphql', 'gql', 'svelte', 'typescriptreact', 'javascriptreact' },
})

-- configure sql language server
lspconfig['sqlls'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { 'sql' },
})

-- configure python server
lspconfig['pyright'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure lua server (with special settings)
lspconfig['lua_ls'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand('$VIMRUNTIME/lua')] = true,
					[vim.fn.stdpath('config') .. '/lua'] = true,
				},
			},
		},
	},
})

local rt = require('rust-tools')

-- local codelldb_path = '~/.local/share/nvim/mason/bin'

rt.setup({
	server = {
		on_attach = function(_, bufnr)
			on_attach(_, bufnr)
			-- Hover actions
			keymap.set('n', '<leader>ha', rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			-- keymap.set('n', '<leader>ca', rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
})

-- typescript-tools
require('typescript-tools').setup({
	on_attach = on_attach,
})

vim.keymap.set('n', '<leader>tso', vim.cmd.TSToolsOrganizeImports, { desc = '[ts-tools] organize imports' })
vim.keymap.set('n', '<leader>tss', vim.cmd.TSToolsSortImports, { desc = '[ts-tools] sort imports' })
vim.keymap.set('n', '<leader>tsr', vim.cmd.TSToolsRemoveUnused, { desc = '[ts-tools] remove unused statements' })
vim.keymap.set('n', '<leader>tsx', vim.cmd.TSToolsRemoveUnusedImports, { desc = '[ts-tools] remove unused imports' })
vim.keymap.set('n', '<leader>tsa', vim.cmd.TSToolsAddMissingImports, { desc = '[ts-tools] add missing imports' })
vim.keymap.set('n', '<leader>tsk', function()
	on_attach(nil, vim.api.nvim_get_current_buf())
end, { desc = '[ts-tools] add missing imports' })
