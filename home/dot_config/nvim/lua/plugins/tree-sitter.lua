vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
})

-- Parser names to install (NOT filetypes — see below).
local parsers = {
	"typescript",
	"javascript",
	"tsx",
	"svelte",
	"go",
	"nix",
	"markdown",
	"json",
	"css",
	"html",
	"toml",
	"yaml",
	"lua",
	"kdl",
	"prisma",
	"todotxt",
}

-- Neovim filetypes that should get treesitter highlighting. These differ from
-- the parser names: .tsx -> filetype `typescriptreact` (tsx parser),
-- .jsx -> filetype `javascriptreact` (javascript parser).
local filetypes = {
	"typescript",
	"typescriptreact",
	"javascript",
	"javascriptreact",
	"svelte",
	"go",
	"nix",
	"markdown",
	"json",
	"css",
	"html",
	"toml",
	"yaml",
	"lua",
	"kdl",
	"prisma",
	"todotxt",
}

-- Associate todo.txt and done.txt with the todotxt filetype so treesitter
-- highlighting kicks in for them.
vim.filetype.add({
	filename = {
		["todo.txt"] = "todotxt",
		["done.txt"] = "todotxt",
	},
})

-- Map the mismatched filetypes to their parser so vim.treesitter.start() resolves them.
vim.treesitter.language.register("tsx", { "typescriptreact" })
vim.treesitter.language.register("javascript", { "javascriptreact" })

require("nvim-treesitter").install(parsers)

local function try_start(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	if vim.tbl_contains(filetypes, vim.bo[buf].filetype) then
		pcall(vim.treesitter.start, buf)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = filetypes,
	callback = function(args)
		try_start(args.buf)
	end,
})

-- The FileType event for the buffer opened on startup (e.g. `nvim file.tsx`)
-- can fire before this plugin loads, so the autocmd above misses it. Kick off
-- highlighting for any buffers that are already open.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
	if vim.api.nvim_buf_is_loaded(buf) then
		try_start(buf)
	end
end
