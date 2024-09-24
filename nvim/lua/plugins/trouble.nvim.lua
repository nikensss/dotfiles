return {
	'folke/trouble.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	opts = {},
	config = function()
		vim.keymap.set('n', '<leader>ee', function()
			require('trouble').toggle('diagnostics')
		end, { desc = '[trouble] toggle' })

		vim.keymap.set('n', '<leader>ew', function()
			require('trouble').toggle('workspace_diagnostics')
		end, { desc = '[trouble] toggle workspace diagnostics' })

		vim.keymap.set('n', '<leader>ed', function()
			require('trouble').toggle('document_diagnostics')
		end, { desc = '[trouble] toggle document diagnostics' })

		vim.keymap.set('n', '<leader>eq', function()
			require('trouble').toggle('quickfix')
		end, { desc = '[trouble] toggle quickfix' })

		vim.keymap.set('n', '<leader>el', function()
			require('trouble').toggle('loclist')
		end, { desc = '[trouble] toggle loclist' })

		vim.keymap.set('n', '[x', function()
			require('trouble').previous({ skip_groups = true, jump = true })
		end, { desc = '[trouble] previous diagnostic' })

		vim.keymap.set('n', ']x', function()
			require('trouble').next({ skip_groups = true, jump = true })
		end, { desc = '[trouble] next diagnostic' })
	end,
}
