require('nvim-treesitter.configs').setup({
	-- A list of parser names, or 'all' (the four listed parsers should always be installed)
	ensure_installed = {
		'astro',
		'bash',
		'c',
		'css',
		'dockerfile',
		'eex',
		'elixir',
		'erlang',
		'gitignore',
		'gleam',
		'go',
		'graphql',
		'heex',
		'html',
		'javascript',
		'json',
		'jsonc',
		'lua',
		'markdown',
		'markdown_inline',
		'prisma',
		'python',
		'regex',
		'rust',
		'scss',
		'sql',
		'toml',
		'tsx',
		'typescript',
		'vim',
		'xml',
		'yaml',
		'zig',
		'diff',
	},
	ignore_install = {},
	sync_install = false,
	auto_install = true,
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = 'grn',
			node_incremental = 'grn',
			scope_incremental = 'grc',
			node_decremental = 'grm',
		},
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	refactor = {
		enable = true,
		highlight_definitions = { enable = true },
		highlight_current_scope = { enable = false },
		navigation = {
			enable = true,
			keymaps = {
				goto_previous_usage = '[r',
				goto_next_usage = ']r',
			},
		},
	},
	textobjects = {
		enable = true,
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['ad'] = { query = '@lexical_declaration.outer', desc = 'Select a whole assignment' },
				['id'] = { query = '@lexical_declaration.inner', desc = 'Select inner part of an assignment' },
				['vd'] = { query = '@lexical_declaration.value', desc = 'Select value (rhs) part of an assignment' },
				['nd'] = { query = '@lexical_declaration.name', desc = 'Select name (lhs) part of an assignment' },

				['at'] = { query = '@ts_type.full', desc = 'Select type definition' },
				['vt'] = { query = '@ts_type.value', desc = 'Select type definition value' },
				['nt'] = { query = '@ts_type.name', desc = 'Select type definition name' },

				-- works for javascript/typescript files (custom capture defined in after/queries/ecma/textobjects.scm)
				['a:'] = { query = '@property.outer', desc = 'Select outer part of an object property' },
				['i:'] = { query = '@property.inner', desc = 'Select inner part of an object property' },

				['ak'] = { query = '@property.key', desc = 'Select left part of an object property' },
				['av'] = { query = '@property.value', desc = 'Select right part of an object property' },

				['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
				['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },

				['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
				['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

				['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
				['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },

				['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
				['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },

				['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
				['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },

				['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
				['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>na'] = '@parameter.inner',
				['<leader>n:'] = '@property.outer',
				['<leader>nm'] = '@function.outer',
			},
			swap_previous = {
				['<leader>pa'] = '@parameter.inner',
				['<leader>p:'] = '@property.outer',
				['<leader>pm'] = '@function.outer',
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				[']d'] = { query = '@lexical_declaration.outer', desc = 'Next lexical declaration start' },
				[']f'] = { query = '@call.outer', desc = 'Next function call start' },
				[']m'] = { query = '@function.outer', desc = 'Next method/function def start' },
				[']c'] = { query = '@class.outer', desc = 'Next class start' },
				[']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
				[']l'] = { query = '@loop.outer', desc = 'Next loop start' },
				[']t'] = { query = '@ts_type.full', desc = 'Next type start' },

				-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
				-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
				[']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
				[']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
			},
			goto_next_end = {
				[']D'] = { query = '@lexical_declaration.outer', desc = 'Next lexical declaration end' },
				[']F'] = { query = '@call.outer', desc = 'Next function call end' },
				[']M'] = { query = '@function.outer', desc = 'Next method/function def end' },
				[']C'] = { query = '@class.outer', desc = 'Next class end' },
				[']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
				[']L'] = { query = '@loop.outer', desc = 'Next loop end' },
				[']T'] = { query = '@ts_type.type', desc = 'Next type end' },
			},
			goto_previous_start = {
				['[d'] = { query = '@lexical_declaration.outer', desc = 'Prev lexical declaration start' },
				['[f'] = { query = '@call.outer', desc = 'Prev function call start' },
				['[m'] = { query = '@function.outer', desc = 'Prev method/function def start' },
				['[c'] = { query = '@class.outer', desc = 'Prev class start' },
				['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
				['[l'] = { query = '@loop.outer', desc = 'Prev loop start' },
				['[t'] = { query = '@ts_type.type', desc = 'Prev type start' },
			},
			goto_previous_end = {
				['[D'] = { query = '@lexical_declaration.outer', desc = 'Prev lexical declaration end' },
				['[F'] = { query = '@call.outer', desc = 'Prev function call end' },
				['[M'] = { query = '@function.outer', desc = 'Prev method/function def end' },
				['[C'] = { query = '@class.outer', desc = 'Prev class end' },
				['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
				['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },
				['[T'] = { query = '@ts_type.type', desc = 'Prev type end' },
			},
		},
	},
})

local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

-- vim way: ; goes to the direction you were moving.
vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)
