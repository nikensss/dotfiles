local dap = require('dap')

local function debugJest(testName, filename)
  print('starting ' .. testName .. ' in ' .. filename)
  dap.run({
    type = 'node2',
    request = 'launch',
    cwd = vim.fn.getcwd(),
    runtimeArgs = { '--inspect-brk', 'jest', '--no-coverage', '-t', testName, '--', filename },
    sourceMaps = true,
    protocol = 'inspector',
    skipFiles = { '<node_internals>/**' },
    console = 'integratedTerminal',
    port = 9229,
  })
end

local function attachDebugger()
  local port = vim.fn.input('Attach to port: ', '9229')

  dap.run({
    type = 'node2',
    request = 'attach',
    name = 'Attach Program (Node2 with ts-node)',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    skipFiles = { '<node_internals>/**' },
    port = port,
  })
end

return {
  debugJest = debugJest,
  attachDebugger = attachDebugger,
}
