local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local options = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>sg', builtin.live_grep, options)
vim.keymap.set('n', '<leader>sf', builtin.find_files, options)
vim.keymap.set('n', '<leader>sp', builtin.git_files, options)
vim.keymap.set('n', '<leader>sb', builtin.buffers, options)
vim.keymap.set('n', '<leader>sh', builtin.help_tags, options)
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, options)
vim.keymap.set('n', '<leader>sc', builtin.current_buffer_fuzzy_find, options)
vim.keymap.set('n', '<leader>sk', builtin.keymaps, options)
vim.keymap.set('n', '<leader>ch', builtin.command_history, options)
vim.keymap.set('n', '<leader>cs', builtin.lsp_document_symbols, options)
vim.keymap.set('n', '<leader>sw', builtin.lsp_workspace_symbols, options)
vim.keymap.set('n', '<leader>ss', builtin.lsp_dynamic_workspace_symbols, options)

require('telescope').setup({
  defaults = {
    mappings = {
      n = {
        ['<C-d>'] = actions.delete_buffer,
        ['<C-s>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<C-f>'] = actions.send_selected_to_qflist + actions.open_qflist
      },
      i = {
        ['<C-d>'] = actions.delete_buffer,
        ['<C-s>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<C-f>'] = actions.send_selected_to_qflist + actions.open_qflist
      }
    }
  }
})
