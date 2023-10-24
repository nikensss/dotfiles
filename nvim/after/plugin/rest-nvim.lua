require('rest-nvim').setup({
	-- Open request results in a horizontal split
	result_split_horizontal = false,
	-- Keep the http file buffer above|left when split horizontal|vertical
	result_split_in_place = true,
	-- Skip SSL verification, useful for unknown certificates
	skip_ssl_verification = false,
	-- Encode URL before making request
	encode_url = true,
	-- Highlight request on run
	highlight = {
		enabled = true,
		timeout = 150,
	},
	result = {
		-- toggle showing URL, HTTP info, headers at top the of result window
		show_url = true,
		-- show the generated curl command in case you want to launch
		-- the same request via the terminal (can be verbose)
		show_curl_command = true,
		show_http_info = true,
		show_headers = true,
		-- executables or functions for formatting response body [optional]
		-- set them to false if you want to disable them
		formatters = {
			json = 'jq',
			html = function(body)
				return vim.fn.system({ 'tidy', '-i', '-q', '-' }, body)
			end,
		},
	},
	-- Jump to request line on run
	jump_to_request = false,
	env_file = '.env',
	custom_dynamic_variables = {},
	yank_dry_run = true,
})

vim.keymap.set('n', '<leader>rr', '<Plug>RestNvim', { desc = '[rest.nvim] send request under cursor', silent = true })
vim.keymap.set('n', '<leader>rp', '<Plug>RestNvimPreview', { desc = '[rest.nvim] show request preview', silent = true })
vim.keymap.set('n', '<leader>rl', '<Plug>RestNvimLast', { desc = '[rest.nvim] send last request', silent = true })
