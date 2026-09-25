vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local cwd = vim.loop.cwd() or vim.fn.getcwd()

local web = { "prettierd", "prettier", stop_after_first = true }
local oxc_root = vim.fs.root(cwd, { ".oxfmtrc", "oxfmt.config.ts", "oxfmt.config.js" })

if oxc_root then
	table.insert(web, 1, "oxfmt")
end

-- Limit biome detection to current working directory
local biome_root = vim.fs.root(cwd, { "biome.json", "biome.jsonc" })
local deno_root = vim.fs.root(cwd, { "deno.json", "deno.jsonc" })

if deno_root then
	table.insert(web, 1, "deno_fmt")
end

if biome_root then
	table.insert(web, 1, "biome")
end

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
		go = { "gofumpt", "goimports" },
		json = web,
		jsonc = web,
		javascript = web,
		typescript = web,
		javascriptreact = web,
		typescriptreact = web,
		html = web,
		css = web,
		markdown = web,
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
})

wk.add({
	{ "<leader>l", group = "lsp" },
	{
		"<leader>lf",
		function()
			require("conform").format({ async = true })
		end,
		desc = "Format document",
		silent = true,
	},
})
