local neotest = require('neotest')
neotest.setup({
	adapters = {
		require('neotest-rust')({}),
		require('neotest-jest')({
			jestConfigFile = function()
				local file = vim.fn.expand('%:p')
				if string.find(file, '/packages/') then
					local tsjestjs = string.match(file, '(.-/[^/]+/)src') .. 'ts-jest.config.js'
					if vim.fn.filereadable(vim.fn.expand(tsjestjs)) == 1 then
						return tsjestjs
					end

					local tsjestjson = string.match(file, '(.-/[^/]+/)src') .. 'ts-jest.config.json'
					if vim.fn.filereadable(vim.fn.expand(tsjestjson)) == 1 then
						return tsjestjson
					end

					local jestjs = string.match(file, '(.-/[^/]+/)src') .. 'jest.config.js'
					if vim.fn.filereadable(vim.fn.expand(jestjs)) == 1 then
						return jestjs
					end

					return string.match(file, '(.-/[^/]+/)src') .. 'jest.config.json'
				end

				local tsjestjs = vim.fn.getcwd() .. '/ts-jest.config.js'
				if vim.fn.filereadable(vim.fn.expand(tsjestjs)) == 1 then
					return tsjestjs
				end

				local tsjestjson = vim.fn.getcwd() .. '/ts-jest.config.json'
				if vim.fn.filereadable(vim.fn.expand(tsjestjson)) == 1 then
					return tsjestjson
				end

				local jestjs = vim.fn.getcwd() .. '/jest.config.js'
				if vim.fn.filereadable(vim.fn.expand(jestjs)) == 1 then
					return jestjs
				end

				return vim.fn.getcwd() .. '/jest.config.json'
			end,
			cwd = function()
				local file = vim.fn.expand('%:p')
				if string.find(file, '/packages/') then
					return string.match(file, '(.-/[^/]+/)src')
				end
				return vim.fn.getcwd()
			end,
		}),
		require('neotest-plenary'),
		require('neotest-vim-test')({
			ignore_file_types = { 'javascript', 'typescript', 'vim', 'lua' },
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
