local neotest = require('neotest')
neotest.setup({
	adapters = {
		require('neotest-jest')({
			jestConfigFile = function()
				local file = vim.fn.expand('%:p')

				local configFiles = {
					'ts-jest.config.js',
					'ts-jest.config.json',
					'jest.config.js',
					'jest.config.json',
				}

				if string.find(file, '/packages/') then
					for _, configFile in ipairs(configFiles) do
						local jestConfig = string.match(file, '(.-/[^/]+/)src') .. configFile
						if vim.fn.filereadable(vim.fn.expand(jestConfig)) == 1 then
							return jestConfig
						end
					end
				end

				for _, configFile in ipairs(configFiles) do
					local jestConfig = vim.fn.getcwd() .. '/' .. configFile
					if vim.fn.filereadable(vim.fn.expand(jestConfig)) == 1 then
						return jestConfig
					end
				end
			end,
			cwd = function()
				local file = vim.fn.expand('%:p')

				if string.find(file, '/packages/') then
					return string.match(file, '(.-/[^/]+/)src')
				end

				return vim.fn.getcwd()
			end,
		}),
		require('neotest-rust')({}),
		require('neotest-plenary'),
		require('neotest-vim-test')({
			ignore_file_types = { 'javascript', 'typescript', 'vim', 'lua', 'rs' },
		}),
	},
})

vim.keymap.set('n', '<leader>tt', function()
	neotest.run.run()
end)

vim.keymap.set('n', '<leader>td', function()
	neotest.run.run({ strategy = 'dap' })
end)

vim.keymap.set('n', '<leader>tf', function()
	neotest.run.run(vim.fn.expand('%'))
end)

vim.keymap.set('n', '<leader>tp', function()
	neotest.summary.toggle()
end)

vim.keymap.set('n', '<leader>tv', function()
	neotest.output.open({ enter = true })
end)
