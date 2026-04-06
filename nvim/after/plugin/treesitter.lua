-- Install parsers
require('nvim-treesitter').install({
	'astro',
	'bash',
	'c',
	'css',
	'dockerfile',
	'eex',
	'elixir',
	'erlang',
	'gitcommit',
	'gitignore',
	'gleam',
	'graphql',
	'heex',
	'html',
	'javascript',
	'json',
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
})

-- Enable treesitter highlighting for all filetypes with a parser
vim.api.nvim_create_autocmd('FileType', {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- Incremental selection
vim.keymap.set('n', 'grn', function()
	vim.treesitter.inspect()
end)

-- Textobjects setup
local select = require('nvim-treesitter-textobjects.select')
local swap = require('nvim-treesitter-textobjects.swap')
local move = require('nvim-treesitter-textobjects.move')

require('nvim-treesitter-textobjects').setup({
	select = {
		lookahead = true,
	},
	move = {
		set_jumps = true,
	},
})

-- Select keymaps
local select_maps = {
	['ad'] = { '@lexical_declaration.outer', 'Select a whole assignment' },
	['id'] = { '@lexical_declaration.inner', 'Select inner part of an assignment' },
	['vd'] = { '@lexical_declaration.value', 'Select value (rhs) part of an assignment' },
	['nd'] = { '@lexical_declaration.name', 'Select name (lhs) part of an assignment' },
	['at'] = { '@ts_type.full', 'Select type definition' },
	['vt'] = { '@ts_type.value', 'Select type definition value' },
	['nt'] = { '@ts_type.name', 'Select type definition name' },
	['a:'] = { '@property.outer', 'Select outer part of an object property' },
	['i:'] = { '@property.inner', 'Select inner part of an object property' },
	['ak'] = { '@property.key', 'Select left part of an object property' },
	['av'] = { '@property.value', 'Select right part of an object property' },
	['aa'] = { '@parameter.outer', 'Select outer part of a parameter/argument' },
	['ia'] = { '@parameter.inner', 'Select inner part of a parameter/argument' },
	['ai'] = { '@conditional.outer', 'Select outer part of a conditional' },
	['ii'] = { '@conditional.inner', 'Select inner part of a conditional' },
	['al'] = { '@loop.outer', 'Select outer part of a loop' },
	['il'] = { '@loop.inner', 'Select inner part of a loop' },
	['af'] = { '@call.outer', 'Select outer part of a function call' },
	['if'] = { '@call.inner', 'Select inner part of a function call' },
	['am'] = { '@function.outer', 'Select outer part of a method/function definition' },
	['im'] = { '@function.inner', 'Select inner part of a method/function definition' },
	['ac'] = { '@class.outer', 'Select outer part of a class' },
	['ic'] = { '@class.inner', 'Select inner part of a class' },
}

for keys, mapping in pairs(select_maps) do
	vim.keymap.set({ 'x', 'o' }, keys, function()
		select.select_textobject(mapping[1], 'textobjects')
	end, { desc = mapping[2] })
end

-- Swap keymaps
local swap_next_maps = {
	['<leader>na'] = '@parameter.inner',
	['<leader>n:'] = '@property.outer',
	['<leader>nm'] = '@function.outer',
}

local swap_prev_maps = {
	['<leader>pa'] = '@parameter.inner',
	['<leader>p:'] = '@property.outer',
	['<leader>pm'] = '@function.outer',
}

for keys, query in pairs(swap_next_maps) do
	vim.keymap.set('n', keys, function()
		swap.swap_next(query)
	end)
end

for keys, query in pairs(swap_prev_maps) do
	vim.keymap.set('n', keys, function()
		swap.swap_previous(query)
	end)
end

-- Move keymaps
local move_maps = {
	-- goto_next_start
	{ ']d', 'goto_next_start', '@lexical_declaration.outer', 'textobjects', 'Next lexical declaration start' },
	{ ']f', 'goto_next_start', '@call.outer', 'textobjects', 'Next function call start' },
	{ ']m', 'goto_next_start', '@function.outer', 'textobjects', 'Next method/function def start' },
	{ ']c', 'goto_next_start', '@class.outer', 'textobjects', 'Next class start' },
	{ ']i', 'goto_next_start', '@conditional.outer', 'textobjects', 'Next conditional start' },
	{ ']l', 'goto_next_start', '@loop.outer', 'textobjects', 'Next loop start' },
	{ ']t', 'goto_next_start', '@ts_type.full', 'textobjects', 'Next type start' },
	{ ']s', 'goto_next_start', '@local.scope', 'locals', 'Next scope' },
	{ ']z', 'goto_next_start', '@fold', 'folds', 'Next fold' },
	-- goto_next_end
	{ ']D', 'goto_next_end', '@lexical_declaration.outer', 'textobjects', 'Next lexical declaration end' },
	{ ']F', 'goto_next_end', '@call.outer', 'textobjects', 'Next function call end' },
	{ ']M', 'goto_next_end', '@function.outer', 'textobjects', 'Next method/function def end' },
	{ ']C', 'goto_next_end', '@class.outer', 'textobjects', 'Next class end' },
	{ ']I', 'goto_next_end', '@conditional.outer', 'textobjects', 'Next conditional end' },
	{ ']L', 'goto_next_end', '@loop.outer', 'textobjects', 'Next loop end' },
	{ ']T', 'goto_next_end', '@ts_type.type', 'textobjects', 'Next type end' },
	-- goto_previous_start
	{ '[d', 'goto_previous_start', '@lexical_declaration.outer', 'textobjects', 'Prev lexical declaration start' },
	{ '[f', 'goto_previous_start', '@call.outer', 'textobjects', 'Prev function call start' },
	{ '[m', 'goto_previous_start', '@function.outer', 'textobjects', 'Prev method/function def start' },
	{ '[c', 'goto_previous_start', '@class.outer', 'textobjects', 'Prev class start' },
	{ '[i', 'goto_previous_start', '@conditional.outer', 'textobjects', 'Prev conditional start' },
	{ '[l', 'goto_previous_start', '@loop.outer', 'textobjects', 'Prev loop start' },
	{ '[t', 'goto_previous_start', '@ts_type.type', 'textobjects', 'Prev type start' },
	-- goto_previous_end
	{ '[D', 'goto_previous_end', '@lexical_declaration.outer', 'textobjects', 'Prev lexical declaration end' },
	{ '[F', 'goto_previous_end', '@call.outer', 'textobjects', 'Prev function call end' },
	{ '[M', 'goto_previous_end', '@function.outer', 'textobjects', 'Prev method/function def end' },
	{ '[C', 'goto_previous_end', '@class.outer', 'textobjects', 'Prev class end' },
	{ '[I', 'goto_previous_end', '@conditional.outer', 'textobjects', 'Prev conditional end' },
	{ '[L', 'goto_previous_end', '@loop.outer', 'textobjects', 'Prev loop end' },
	{ '[T', 'goto_previous_end', '@ts_type.type', 'textobjects', 'Prev type end' },
}

for _, m in ipairs(move_maps) do
	vim.keymap.set({ 'n', 'x', 'o' }, m[1], function()
		move[m[2]](m[3], m[4])
	end, { desc = m[5] })
end

-- Repeatable moves
local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')

vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
