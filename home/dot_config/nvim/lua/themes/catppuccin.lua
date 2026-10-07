vim.pack.add({ "https://github.com/catppuccin/nvim" })

require("catppuccin").setup({
	transparent_background = true,
	term_colors = true,

	integrations = {
		snacks = { enabled = true },
	},

	custom_highlights = function(colors)
		return {
			NormalFloat = { bg = colors.none },
			FloatBorder = { bg = colors.none },
			FloatTitle = { bg = colors.none },
		}
	end,
})
