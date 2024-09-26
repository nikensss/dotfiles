local telescope_builtin = require('telescope.builtin')
local pickers = require('telescope.pickers')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local get_session_path = require('ricard.functions').get_session_path
local save_qf_list = require('ricard.functions').save_qf_list
local load_qf_list = require('ricard.functions').load_qf_list

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>qq', function()
	vim.cmd('q!')
end)
vim.keymap.set('n', '<leader>qa', vim.cmd.quitall)
vim.keymap.set('n', '<leader>qc', vim.cmd.cclose)
vim.keymap.set('n', '<leader>qo', vim.cmd.copen)

vim.keymap.set('x', '<leader>p', [["_dP]])

vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv')
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv')

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')

vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', 'Q', '<nop>')

vim.keymap.set('n', '<leader><leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>x', '<cmd>!chmod u+x %<CR>', { silent = true })

-- increment/decrement amount
vim.keymap.set('n', '+', '<C-a>')
vim.keymap.set('n', '-', '<C-x>')

-- window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
vim.keymap.set('n', '<leader>v', '<C-w><C-v>')

-- resize windows
vim.keymap.set('n', '<leader>+', '5<C-w>>')
vim.keymap.set('n', '<leader>-', '5<C-w><')
vim.keymap.set('n', '<leader><leader>+', '<C-w>15+')
vim.keymap.set('n', '<leader><leader>-', '<C-w>15-')

-- tabs
vim.keymap.set('n', '<leader>tn', vim.cmd.tabe)
vim.keymap.set('n', '<leader>tc', vim.cmd.tabc)
vim.keymap.set('n', ']t', vim.cmd.tabn)
vim.keymap.set('n', '[t', vim.cmd.tabp)

-- terminal mode
vim.keymap.set('t', '<ESC>', '<c-\\><c-n>')

-- open terminal in vertical split
vim.keymap.set('n', '<C-w><C-t>', '<C-w>v<C-w>l:terminal<CR><C-w>T:TabRename term<CR>a')

-- colorschemes
local function theme_picker()
	local themes = {
		{
			name = 'catppuccin - mocha',
			activate = function()
				vim.cmd.colorscheme('catppuccin')
				vim.cmd.Catppuccin('mocha')
			end,
		},
		{
			name = 'catppuccin - macchiato',
			activate = function()
				vim.cmd.colorscheme('catppuccin')
				vim.cmd.Catppuccin('macchiato')
			end,
		},
		{
			name = 'catppuccin - frappe',
			activate = function()
				vim.cmd.colorscheme('catppuccin')
				vim.cmd.Catppuccin('frappe')
			end,
		},
		{
			name = 'catppuccin - latte',
			activate = function()
				vim.cmd.colorscheme('catppuccin')
				vim.cmd.Catppuccin('latte')
			end,
		},
		{
			name = 'tokyonight - night',
			activate = function()
				vim.cmd.colorscheme('tokyonight-night')
			end,
		},
		{
			name = 'tokyonight - storm',
			activate = function()
				vim.cmd.colorscheme('tokyonight-storm')
			end,
		},
		{
			name = 'tokyonight - moon',
			activate = function()
				vim.cmd.colorscheme('tokyonight-moon')
			end,
		},
		{
			name = 'tokyonight - day',
			activate = function()
				vim.cmd.colorscheme('tokyonight-day')
			end,
		},
		{
			name = 'obscure',
			activate = function()
				vim.cmd.colorscheme('obscure')
			end,
		},
	}

	local names = {}
	for _, theme in ipairs(themes) do
		table.insert(names, theme.name)
	end

	pickers
		.new({}, {
			prompt_title = 'Themes',
			finder = require('telescope.finders').new_table({ results = names }),
			sorter = require('telescope.config').values.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					for _, theme in ipairs(themes) do
						if theme.name == selection.value then
							theme.activate()
							break
						end
					end
				end)

				return true
			end,
		})
		:find()
end

vim.keymap.set('n', '<leader><leader>tp', theme_picker, { silent = true, desc = '[t]heme [p]icker' })

local function load_session_file(session_file)
	vim.cmd('source ' .. session_file)
	load_qf_list(string.gsub(session_file, '.session$', '.qf'))
	print('loaded session from ' .. session_file)
end

local function show_available_sessions(on_selection)
	telescope_builtin.find_files({
		prompt_title = 'Available sessions',
		cwd = '~/.config/nvim/',
		hidden = true,
		find_command = { 'find', '.', '-type', 'f', '-name', '*.session' },
		layout_config = {
			prompt_position = 'top',
		},
		attach_mappings = function(prompt_bufnr, map)
			on_selection(prompt_bufnr, map)
			return true
		end,
	})
end

local function pick_session()
	show_available_sessions(function(prompt_bufnr, map)
		map({ 'i', 'n' }, '<CR>', function()
			local selection = action_state.get_selected_entry()
			actions.close(prompt_bufnr)
			local session_path = '~/.config/nvim/' .. string.sub(selection.value, 3)
			load_session_file(vim.fn.expand(session_path))
		end)
	end)
end

vim.keymap.set('n', '<leader>ls', function()
	local session_path = get_session_path()
	if vim.fn.filereadable(vim.fn.expand(session_path)) == 1 then
		load_session_file(session_path)
	else
		pick_session()
	end
end, { silent = true, desc = '[l]oad [s]ession' })

vim.keymap.set('n', '<leader>ps', pick_session, { silent = true, desc = '[p]ick [s]ession' })

vim.keymap.set('n', '<leader>ms', function()
	local session_path = get_session_path()
	vim.cmd('mksession! ' .. session_path)
	save_qf_list()
	print('session saved to ' .. session_path)
end, { silent = true, desc = '[m]ake [s]ession' })

vim.keymap.set(
	'v',
	'<leader>ip',
	'<Plug>(nvim-surround-visual)`<Plug>(nvim-surround-normal)i`}i$<ESC>',
	{ silent = false, noremap = true, desc = 'interpolate string' }
)
vim.keymap.set(
	'n',
	'<leader>ir',
	'<Plug>(nvim-surround-delete)`x<Plug>(nvim-surround-delete)}',
	{ silent = false, noremap = true, desc = 'remove interpolation' }
)
