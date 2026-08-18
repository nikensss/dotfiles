-- neo-tree's upward worktree lookup skips the worktree root itself, so `]g`/`[g` bail out silently whenever the
-- cursor sits on the tree's root node. Priming the lookup cache with the root path makes the lookup resolve.
local function git_modified(command)
	return function(state)
		local git = require('neo-tree.git')

		if git.worktrees[state.path] then
			git._upward_worktree_cache[state.path] = state.path
		end

		require('neo-tree.sources.filesystem.commands')[command](state)
	end
end

return {
	'nvim-neo-tree/neo-tree.nvim',
	branch = 'v3.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
		'MunifTanjim/nui.nvim',
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	opts = {
		filesystem = {
			follow_current_file = {
				enabled = true,
			},
			hijack_netrw_behavior = 'disabled',

			window = {
				fuzzy_finder_mappings = {
					['<esc>'] = 'close_keep_filter',
					['<C-x>'] = 'close_clear_filter',
				},

				mappings = {
					[']g'] = git_modified('next_git_modified'),
					['[g'] = git_modified('prev_git_modified'),
				},
			},
		},

		window = {
			position = 'float',
		},
	},
}
