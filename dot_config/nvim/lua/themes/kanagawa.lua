vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })

require("kanagawa").setup({
	transparent = true,
	background = {
		dark = "dragon",
		light = "lotus",
	},
	colors = {
		theme = {
			all = {
				ui = {
					bg_gutter = "none",
				},
			},
		},
	},
	overrides = function(colors)
		-- set floating windows transparent
		local theme = colors.theme
		return {
			Pmenu = { fg = theme.ui.shade0, bg = "none" }, -- add `blend = vim.o.pumblend` to enable transparency
			PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
			PmenuSbar = { bg = theme.ui.bg_m1 },
			PmenuThumb = { bg = theme.ui.bg_p2 },

			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
			NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

			BlinkCmpMenuBorder = { fg = "none", bg = "none" },
		}
	end,
})
