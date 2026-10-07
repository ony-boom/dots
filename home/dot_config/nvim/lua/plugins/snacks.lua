vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
	input = { enabled = true },
	words = { enabled = true },
	picker = {
		enabled = true,
		sources = {
			grep = {
				hidden = true,
			},
			explorer = {
				ignored = true,
				hidden = true,
				replace_netrw = true,
			},
		},
	},

	statuscolumn = {
		enabled = true,
		folds = {
			open = true,
		},
	},
})

wk.add({
	{ "<leader>f", group = "find" },
	{
		"<leader>e",
		function()
			Snacks.explorer()
		end,
		desc = "File explorer",
		silent = true,
	},
	{
		"<leader>ff",
		function()
			Snacks.picker.files()
		end,
		desc = "Find files",
		silent = true,
	},
	{
		"<leader>fb",
		function()
			Snacks.picker.buffers()
		end,
		desc = "Buffers",
		silent = true,
	},
	{
		"<leader>fw",
		function()
			Snacks.picker.grep()
		end,
		desc = "Grep",
		silent = true,
	},
	{
		"<leader>fo",
		function()
			Snacks.picker.recent()
		end,
		desc = "Recent files",
		silent = true,
	},
	{
		"<leader>h",
		function()
			Snacks.picker.help()
		end,
		desc = "Vim help",
		silent = true,
	},
	{
		'"',
		function()
			Snacks.picker.registers()
		end,
		desc = "Registers",
		silent = true,
	},
	{
		"<leader>ss",
		function()
			Snacks.picker.lsp_symbols()
		end,
		desc = "LSP Symbol",
	},
})
