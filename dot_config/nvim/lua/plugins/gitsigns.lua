vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
})

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		-- Navigation
		vim.keymap.set({ "n", "v" }, "]h", function()
			gs.next_hunk()
		end, { buffer = bufnr, desc = "Go to next hunk" })
		vim.keymap.set({ "n", "v" }, "[h", function()
			gs.prev_hunk()
		end, { buffer = bufnr, desc = "Go to previous hunk" })

		-- Actions
		vim.keymap.set("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { buffer = bufnr, desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { buffer = bufnr, desc = "Reset hunk" })
		vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { buffer = bufnr, desc = "Preview hunk" })
		vim.keymap.set("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end, { buffer = bufnr, desc = "Blame line" })

		-- Text object
		vim.keymap.set(
			{ "o", "x" },
			"ih",
			":<C-U>Gitsigns select_hunk<CR>",
			{ buffer = bufnr, desc = "Select inner hunk" }
		)
	end,
})
