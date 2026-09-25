vim.pack.add({
	"https://github.com/sainnhe/gruvbox-material",
})

vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_transparent_background = 2

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "gruvbox-material",
	callback = function()
		vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "PmenuSel", { bg = "NONE", reverse = true })
		vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
	end,
})
