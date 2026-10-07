vim.pack.add({
	"https://github.com/folke/which-key.nvim",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/lukas-reineke/indent-blankline.nvim",
})

local wk = require("which-key")

wk.setup()
---@type wk
_G.wk = require("which-key")

require("mini.icons").setup()
require("ibl").setup()

require("plugins.gitsigns")
require("plugins.autopairs")
require("plugins.tree-sitter")
require("plugins.snacks")
require("plugins.formatting")
require("plugins.bufferline")
require("plugins.ai")
