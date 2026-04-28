return {
	'pmizio/typescript-tools.nvim',
	ft = {
		'javascript',
		'javascriptreact',
		'javascript.jsx',
		'typescript',
		'typescriptreact',
		'typescript.tsx',
	},
	dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
	config = function()
		local group = vim.api.nvim_create_augroup('ricard-typescript-tools', { clear = true })
		local lsp_helpers = require('ricard.lsp_helpers')

		local function path_exists(path)
			return path and vim.uv.fs_stat(path) ~= nil
		end

		local function find_upward(start_path, relative_path)
			local dir = vim.fs.dirname(vim.fs.normalize(start_path))
			while dir and dir ~= '' do
				local candidate = dir .. '/' .. relative_path
				if path_exists(candidate) then
					return candidate
				end
				local parent = vim.fs.dirname(dir)
				if not parent or parent == dir then
					break
				end
				dir = parent
			end
		end

		local function global_tsserver_exists()
			local npm = vim.fn.exepath('npm')
			if npm ~= '' then
				local lines = vim.fn.systemlist({ npm, 'root', '-g' })
				local npm_root = lines[1]
				if vim.v.shell_error == 0 and path_exists(npm_root .. '/typescript/lib/tsserver.js') then
					return true
				end
			end

			local tsserver = vim.fn.exepath('tsserver')
			if tsserver ~= '' then
				local bin_dir = vim.fs.dirname(tsserver)
				local prefix = vim.fs.dirname(bin_dir)
				if path_exists(prefix .. '/lib/tsserver.js') then
					return true
				end
				if path_exists(prefix .. '/lib/node_modules/typescript/lib/tsserver.js') then
					return true
				end
			end

			local mason = vim.env.MASON
			if mason and path_exists(mason .. '/packages/typescript-language-server/node_modules/typescript/lib/tsserver.js') then
				return true
			end

			return false
		end

		local function project_tsserver_exists(bufnr)
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname == '' then
				return false
			end

			return find_upward(bufname, 'node_modules/typescript/lib/tsserver.js') ~= nil
				or find_upward(bufname, '.yarn/sdks/typescript/lib/tsserver.js') ~= nil
		end

		local function tsserver_exists(bufnr)
			return project_tsserver_exists(bufnr) or global_tsserver_exists()
		end

		local function setup_typescript_tools()
			if vim.g.ricard_typescript_tools_setup then
				return true
			end

			require('typescript-tools').setup({
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local git_root = vim.fs.root(fname, '.git')
					on_dir(git_root or vim.fn.getcwd())
				end,
				on_attach = function(client, bufnr)
					lsp_helpers.on_attach(client, bufnr)

					local options = { desc = '[ts-tools] organize imports', buffer = bufnr }
					vim.keymap.set('n', '<leader>tso', vim.cmd.TSToolsOrganizeImports, options)

					options = { desc = '[ts-tools] sort imports', buffer = bufnr }
					vim.keymap.set('n', '<leader>tsi', vim.cmd.TSToolsSortImports, options)

					options = { desc = '[ts-tools] remove unused statements', buffer = bufnr }
					vim.keymap.set('n', '<leader>tss', vim.cmd.TSToolsRemoveUnused, options)

					options = { desc = '[ts-tools] remove unused imports', buffer = bufnr }
					vim.keymap.set('n', '<leader>tsu', vim.cmd.TSToolsRemoveUnusedImports, options)

					options = { desc = '[ts-tools] add missing imports', buffer = bufnr }
					vim.keymap.set('n', '<leader>tsa', vim.cmd.TSToolsAddMissingImports, options)

					options = { desc = '[ts-tools] re-attach lsp', buffer = bufnr }
					vim.keymap.set('n', '<leader>tsk', function()
						lsp_helpers.on_attach(client, vim.api.nvim_get_current_buf())
					end, options)
				end,
				capabilities = lsp_helpers.capabilities(),
				settings = {
					tsserver_file_preferences = {
						importModuleSpecifierPreference = 'non-relative',
					},
				},
			})

			vim.g.ricard_typescript_tools_setup = true
			pcall(vim.api.nvim_del_augroup_by_id, group)
			return true
		end

		local function maybe_setup(bufnr)
			if vim.g.ricard_typescript_tools_setup then
				return true
			end

			if tsserver_exists(bufnr) then
				return setup_typescript_tools()
			end

			vim.schedule(function()
				vim.notify_once(
					'[typescript-tools] No tsserver found. Install `typescript` in project or globally.',
					vim.log.levels.WARN
				)
			end)
			return false
		end

		vim.api.nvim_create_autocmd('FileType', {
			group = group,
			pattern = {
				'javascript',
				'javascriptreact',
				'javascript.jsx',
				'typescript',
				'typescriptreact',
				'typescript.tsx',
			},
			callback = function(args)
				maybe_setup(args.buf)
			end,
		})

		maybe_setup(vim.api.nvim_get_current_buf())
	end,
}
