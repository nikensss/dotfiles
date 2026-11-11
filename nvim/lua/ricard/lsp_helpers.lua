local M = {}

function M.on_attach(client, bufnr)
	local navbuddy = require('nvim-navbuddy')
	local navic = require('nvim-navic')

	local keymap = vim.keymap
	local opts = { noremap = true, silent = true, buffer = bufnr }

	if client.server_capabilities.documentSymbolProvider then
		navbuddy.attach(client, bufnr)
		if not navic.is_available(bufnr) then
			navic.attach(client, bufnr)
		end
	end

	opts.desc = 'Show LSP references'
	keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)

	opts.desc = 'Go to declaration'
	keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

	opts.desc = 'Show LSP definitions'
	keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
	keymap.set('n', '<C-g><C-d>', '<C-w><C-v><cmd>Telescope lsp_definitions<CR>', opts)

	opts.desc = 'Show LSP type definitions'
	keymap.set('n', 'gy', '<cmd>Telescope lsp_type_definitions<CR>', opts)

	opts.desc = 'Show LSP implementations'
	keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)

	opts.desc = 'Show incoming calls'
	keymap.set('n', 'gj', '<cmd>Telescope lsp_incoming_calls<CR>', opts)

	opts.desc = 'Show outgoing calls'
	keymap.set('n', 'gk', '<cmd>Telescope lsp_outgoing_calls<CR>', opts)

	opts.desc = 'Smart rename'
	keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

	opts.desc = 'Show buffer diagnostics'
	keymap.set('n', '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<CR>', opts)

	opts.desc = 'Show workspace diagnostics ([s]how [e]rrors)'
	keymap.set('n', '<leader>se', '<cmd>Telescope diagnostics <CR>', opts)

	opts.desc = 'Show line diagnostics'
	keymap.set('n', '<leader>ld', vim.diagnostic.open_float, opts)

	opts.desc = 'Go to previous diagnostic'
	keymap.set('n', '[e', function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, opts)

	opts.desc = 'Go to next diagnostic'
	keymap.set('n', ']e', function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, opts)

	opts.desc = 'Go to previous reference'
	keymap.set('n', '[r', function()
		require('illuminate').goto_prev_reference(true)
	end, opts)

	opts.desc = 'Go to next reference'
	keymap.set('n', ']r', function()
		require('illuminate').goto_next_reference(true)
	end, opts)

	opts.desc = 'Show documentation for what is under cursor'
	keymap.set('n', 'K', vim.lsp.buf.hover, opts)

	opts.desc = 'Signature help'
	keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)

	opts.desc = 'Restart LSP'
	keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts)

	if client:supports_method('textDocument/inlayHint') then
		opts.desc = 'Toggle inlay hints'
		keymap.set('n', '<leader>ih', function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end, opts)
	end
end

local native_typescript_binary_by_root = {}

function M.typescript_project_root(bufnr)
	return vim.fs.root(bufnr, { 'pnpm-lock.yaml', 'package-lock.json', 'yarn.lock', 'bun.lock', 'bun.lockb' })
end

-- TypeScript 7+ ships a native `--lsp` server instead of the tsserver.js that typescript-tools drives.
function M.native_typescript_binary(root)
	if not root then
		return nil
	end

	if native_typescript_binary_by_root[root] == nil then
		native_typescript_binary_by_root[root] = false
		for _, name in ipairs({ 'tsgo', 'tsrs', 'tsc' }) do
			local binary = vim.fs.joinpath(root, 'node_modules/.bin', name)
			if vim.fn.executable(binary) == 1 then
				local version = vim.system({ binary, '--version' }, { text = true }):wait().stdout or ''
				local major = tonumber(version:match('(%d+)%.%d+'))
				if major and major >= 7 then
					native_typescript_binary_by_root[root] = binary
					break
				end
			end
		end
	end

	return native_typescript_binary_by_root[root] or nil
end

function M.capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local ok, blink = pcall(require, 'blink.cmp')
	if ok then
		capabilities = blink.get_lsp_capabilities(capabilities)
	end
	return capabilities
end

return M
