require('gitsigns').setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']h', function()
			if vim.wo.diff then
				return ']h'
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return '<Ignore>'
		end, { expr = true })

		map('n', '[h', function()
			if vim.wo.diff then
				return '[h'
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return '<Ignore>'
		end, { expr = true })

		-- Actions
		map('n', '<leader>hs', gs.stage_hunk, { desc = '[gs] stage hunk' })
		map('n', '<leader>hr', gs.reset_hunk, { desc = '[gs] reset hunk' })
		map('v', '<leader>hs', function()
			gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
		end, { desc = '[gs] stage hunk' })
		map('v', '<leader>hr', function()
			gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
		end, { desc = '[gs] reset hunk' })
		map('n', '<leader>hS', gs.stage_buffer, { desc = '[gs] stage buffer' })
		map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[gs] undo stage hunk' })
		map('n', '<leader>hR', gs.reset_buffer, { desc = '[gs] reset buffer' })
		map('n', '<leader>hp', gs.preview_hunk, { desc = '[gs] preview hunk' })
		map('n', '<leader>hb', function()
			gs.blame_line({ full = true })
		end, { desc = '[gs] blame line' })
		map('n', '<leader>hB', gs.toggle_current_line_blame, { desc = '[gs] toggle current line blame' })
		map('n', '<leader>hd', gs.diffthis, { desc = '[gs] diff this' })
		map('n', '<leader>hD', function()
			gs.diffthis('~')
		end, { desc = '[gs] diff this (cached)' })
		map('n', '<leader>ht', gs.toggle_deleted, { desc = '[gs] toggle deleted' })

		-- Text object
		map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	end,
})
