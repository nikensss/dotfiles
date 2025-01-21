local neotest = require('neotest')
neotest.setup({
	adapters = {
		require('neotest-go')({
			recursive_run = true,
		}),
		require('neotest-jest')({
			jestConfigFile = function(test_file_path)
				local file = test_file_path or vim.fn.expand('%:p')

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
			cwd = function(test_file_path)
				local file = test_file_path or vim.fn.expand('%:p')

				if string.find(file, '/packages/') then
					return string.match(file, '(.-/[^/]+/)src')
				end

				return vim.fn.getcwd()
			end,
		}),
		require('rustaceanvim.neotest'),
		require('neotest-plenary'),
		require('neotest-vim-test')({
			ignore_file_types = { 'javascript', 'typescript', 'vim', 'lua', 'rs' },
		}),
	},
})

vim.keymap.set('n', '<leader>tt', function()
	neotest.run.run()
end, { desc = '[neotest] run nearest' })

vim.keymap.set('n', '<leader>tl', function()
	neotest.run.run_last()
end, { desc = '[neotest] run last' })

vim.keymap.set('n', '<leader>td', function()
	neotest.run.run({ strategy = 'dap' })
end, { desc = '[neotest] debug nearest' })

vim.keymap.set('n', '<leader>tf', function()
	neotest.run.run(vim.fn.expand('%'))
end, { desc = '[neotest] run file' })

vim.keymap.set('n', '<leader>tp', function()
	neotest.summary.toggle()
end, { desc = '[neotest] open panel' })

vim.keymap.set('n', '<leader>tv', function()
	neotest.output.open({ enter = true })
end, { desc = '[neotest] open output' })

vim.keymap.set('n', '<leader>tot', function()
	neotest.output_panel.toggle()
end, { desc = '[neotest] toggle output panel' })

vim.keymap.set('n', '<leader>toc', function()
	neotest.output_panel.clear()
end, { desc = '[neotest] clear output panel' })
