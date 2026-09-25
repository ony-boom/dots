wk.add({
	{ "<Esc>", ":noh<CR>", desc = "Clear search highlights", silent = true },
	{ "<C-s>", ":update<CR>", desc = "Save file", silent = true },
	{ "<leader>c", ":bd<CR>", desc = "Close buffer", silent = true },
	{ "Y", '"+y', mode = "x", desc = "Copy selection to system clipboard", silent = true },
	{ "<C-d>", "<C-d>zz", desc = "Move down with cursor always centered" },
	{ "<C-u>", "<C-u>zz", desc = "Move up with cursor always centered" },
})
