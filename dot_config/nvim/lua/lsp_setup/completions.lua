vim.pack.add({
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
})

require("blink.cmp").setup({
	keymap = { ["<CR>"] = { "accept", "fallback" } },
	fuzzy = { implementation = "prefer_rust_with_warning" },
	appearance = {
		nerd_font_variant = "mono",
	},
	signature = { window = { border = "rounded" } },
	completion = {
		menu = { border = "rounded" },
		documentation = {
			auto_show = false,
			window = { border = "rounded" },
		},
	},
})

local servers = require("lsp_setup.servers")

for _, server in ipairs(servers) do
	local capabilities = require("blink.cmp").get_lsp_capabilities()
	vim.lsp.config(server, {
		capabilities = capabilities,
	})
end
