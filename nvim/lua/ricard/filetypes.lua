vim.filetype.add({
	pattern = {
		['%.env%.[%w_.-]+'] = 'bash',
	},
})
