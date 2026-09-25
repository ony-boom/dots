vim.pack.add({
	{ src = "https://github.com/akinsho/bufferline.nvim", version = vim.version.range("*") },
})

require("bufferline").setup({
	options = {
		show_buffer_close_icons = false,

		offsets = {
			{
				filetype = "neo-tree",
				text = "Neo-tree",
				highlight = "Directory",
				text_align = "left",
			},
			{
				filetype = "snacks_layout_box",
			},
		},

		highlights = require("rose-pine.plugins.bufferline"),
	},
})
