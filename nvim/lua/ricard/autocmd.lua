vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- vim.api.nvim_create_autocmd('BufWritePre', {
--   desc = 'format markdown on write using prettier',
--   group = vim.api.nvim_create_augroup('md_prettier_on_save', { clear = true }),
--   callback = function(opts)
--     if vim.bo[opts.buf].filetype == 'markdown' then
--       vim.cmd.Prettier()
--     end
--   end,
-- })
