local dap = require('dap')

dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = { os.getenv('HOME') .. '/repos/javascript/vscode-node-debug2/out/src/nodeDebug.js' },
}

dap.configurations.typescript = {
    {
        type = 'node2',
        request = 'launch',
        name = 'Launch Program (Node2 with ts-node)',
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
vim.fn.sign_define('DapStopped', { text = '', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpoint', { text = '⏹', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '⏸', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '❌', texthl = '', linehl = '', numhl = '' })

vim.keymap.set('n', '<leader>db', function()
  require('dap').toggle_breakpoint()
end)
vim.keymap.set('n', '<leader>dC', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set('n', '<leader>dO', function()
  require('dap').step_out()
end)
vim.keymap.set('n', '<leader>di', function()
  require('dap').step_into()
end)
vim.keymap.set('n', '<leader>do', function()
  require('dap').step_over()
end)
vim.keymap.set('n', '<leader>dc', function()
  require('dap').continue()
end)
vim.keymap.set('n', '<leader>dh', function()
  require('dap').run_to_cursor()
end)
vim.keymap.set('n', '<leader>dT', function()
  require('dap').terminate()
end)
vim.keymap.set('n', '<leader>dR', function()
  require('dap').clear_breakpoints()
end)
vim.keymap.set('n', '<leader>de', function()
  require('dap').set_exception_breakpoints({ 'all' })
end)
vim.keymap.set('n', '<leader>da', function()
  require('utils').attachDebugger()
end)
vim.keymap.set('n', '<leader>dw', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set('n', '<leader>dW', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)
vim.keymap.set('n', '<leader>dk', ":lua require'dap'.up()<CR>zz")
vim.keymap.set('n', '<leader>dj', ":lua require'dap'.down()<CR>zz")
vim.keymap.set('n', '<leader>dr', ":lua require'dap'.repl.toggle({}, 'vsplit')<CR><C-w>l")

-- nvim-telescope/telescope-dap.nvim
require('telescope').load_extension('dap')
vim.keymap.set('n', '<leader>ds', ':Telescope dap frames<CR>')
vim.keymap.set('n', '<leader>dt', ':Telescope dap commands<CR>')
vim.keymap.set('n', '<leader>dB', ':Telescope dap list_breakpoints<CR>')

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
end)
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close({})
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close({})
end

-- David-Kunz/jester

require('jester').setup({ path_to_jest_run = 'npx jest' })

vim.keymap.set('n', '<leader>tt', function()
  require('jester').run()
end)

vim.keymap.set('n', '<leader>tl', function()
  require('jester').run_last()
end)

vim.keymap.set('n', '<leader>tf', function()
  require('jester').run_file()
end)

vim.keymap.set('n', '<leader>dd', function()
  require('jester').debug()
end)

vim.keymap.set('n', '<leader>dl', function()
  require('jester').debug_last()
end)

vim.keymap.set('n', '<leader>df', function()
  require('jester').debug_file()
end)

vim.keymap.set('n', '<leader>dq', function()
  require('jester').terminate()
end)
