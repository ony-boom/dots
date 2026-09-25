vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/esmuellert/nvim-eslint",
	"https://github.com/b0o/schemastore.nvim",
})

local servers = require("lsp_setup.servers")

vim.lsp.enable(servers)

require("lsp_setup.mappings")
require("lsp_setup.completions")
require("nvim-eslint").setup({})
