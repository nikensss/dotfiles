local dap = require('dap')
require('dap-go').setup()

dap.adapters.node2 = {
	type = 'executable',
	command = 'node',
	args = { os.getenv('HOME') .. '/repos/vscode-node-debug2/out/src/nodeDebug.js' },
}

dap.configurations.typescript = {
	{
		type = 'node2',
		request = 'launch',
		name = 'Debug current script (ts-node)',
		cwd = vim.fn.getcwd(),
		runtimeArgs = { '-r', 'ts-node/register', '-r', 'dotenv/config' },
		runtimeExecutable = 'node',
		args = { '--inspect', '${file}' },
		sourceMaps = true,
		skipFiles = { '<node_internals>/**', 'node_modules/**' },
	},
	{
		type = 'node2',
		request = 'launch',
		name = 'Debug from "./src/index.ts"',
		cwd = vim.fn.getcwd(),
		runtimeArgs = { '-r', 'ts-node/register', '-r', 'dotenv/config' },
		runtimeExecutable = 'node',
		args = { '--inspect', vim.fn.getcwd() .. '/src/index.ts' },
		sourceMaps = true,
		skipFiles = { '<node_internals>/**', 'node_modules/**' },
	},
	{
		type = 'node2',
		request = 'launch',
		name = 'Launch NestJS app',
		cwd = vim.fn.getcwd(),
		runtimeArgs = { '-r', 'ts-node/register', '-r', 'dotenv/config' },
		runtimeExecutable = 'node',
		args = { '--inspect', vim.fn.getcwd() .. '/src/main.ts' },
		sourceMaps = true,
		skipFiles = { '<node_internals>/**', 'node_modules/**' },
	},
}

require('dap').set_log_level('INFO')
dap.defaults.fallback.terminal_win_cmd = '20split new'
vim.fn.sign_define('DapStopped', { text = '⏵', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpoint', { text = '⏹', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '⏸', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '×', texthl = '', linehl = '', numhl = '' })

vim.keymap.set('n', '<leader>db', function()
	require('dap').toggle_breakpoint()
end, { desc = 'toggle breakpoint' })

vim.keymap.set(
	'n',
	'<leader>dC',
	':lua require\'dap\'.set_breakpoint(vim.fn.input(\'Breakpoint condition: \'))<CR>',
	{ desc = 'set breakpoint condition' }
)

vim.keymap.set('n', '<leader>dO', function()
	require('dap').step_out()
end, { desc = '[dap] step out' })

vim.keymap.set('n', '<leader>di', function()
	require('dap').step_into()
end, { desc = '[dap] step into' })

vim.keymap.set('n', '<leader>do', function()
	require('dap').step_over()
end, { desc = '[dap] step over' })

vim.keymap.set('n', '<leader>dc', function()
	require('dap').continue()
end, { desc = '[dap] continue' })

vim.keymap.set('n', '<leader>dh', function()
	require('dap').run_to_cursor()
end, { desc = '[dap] run to cursor' })

vim.keymap.set('n', '<leader>dT', function()
	require('dap').terminate()
end, { desc = '[dap] terminate' })

vim.keymap.set('n', '<leader>dR', function()
	require('dap').clear_breakpoints()
end, { desc = '[dap] clear breakpoints' })

vim.keymap.set('n', '<leader>de', function()
	require('dap').set_exception_breakpoints({ 'all' })
end, { desc = '[dap] set exception breakpoints' })

vim.keymap.set('n', '<leader>da', function()
	require('utils').attachDebugger()
end, { desc = '[dap] attach debugger' })

vim.keymap.set('n', '<leader>dw', function()
	require('dap.ui.widgets').hover()
end, { desc = '[dap] hover' })

vim.keymap.set('n', '<leader>dW', function()
	local widgets = require('dap.ui.widgets')
	widgets.centered_float(widgets.scopes)
end, { desc = '[dap] scopes' })

vim.keymap.set('n', '<leader>dk', ':lua require\'dap\'.up()<CR>zz', { desc = '[dap] up' })
vim.keymap.set('n', '<leader>dj', ':lua require\'dap\'.down()<CR>zz', { desc = '[dap] down' })
vim.keymap.set(
	'n',
	'<leader>dr',
	':lua require\'dap\'.repl.toggle({}, \'vsplit\')<CR><C-w>l',
	{ desc = '[dap] repl toggle' }
)

-- nvim-telescope/telescope-dap.nvim
require('telescope').load_extension('dap')
vim.keymap.set('n', '<leader>ds', ':Telescope dap frames<CR>', { desc = '[dap] frames' })
vim.keymap.set('n', '<leader>dt', ':Telescope dap commands<CR>', { desc = '[dap] commands' })
vim.keymap.set('n', '<leader>dB', ':Telescope dap list_breakpoints<CR>', { desc = '[dap] list breakpoints' })

require('nvim-dap-virtual-text').setup({})
vim.g.dap_virtual_text = true

local dapui = require('dapui')
dapui.setup({
	layouts = {
		{
			elements = {
				'watches',
				'breakpoints',
				'stacks',
				'scopes',
			},
			size = 55, -- # of columns
			position = 'left',
		},
		{
			elements = {
				'console',
				'repl',
			},
			size = 0.25, -- 25% of total lines
			position = 'bottom',
		},
	},
})

vim.keymap.set('n', '<leader>dp', function()
	dapui.toggle({})
end, { desc = '[dap] toggle panel' })

dap.listeners.after.event_initialized['dapui_config'] = function()
	dapui.open({})
end

dap.listeners.before.event_terminated['dapui_config'] = function()
	dapui.close({})
end

dap.listeners.before.event_exited['dapui_config'] = function()
	dapui.close({})
end
