local picker = Snacks.picker

local mappings = {
	{
		mode = { "n", "v" },
		lhs = "<leader>la",
		rhs = vim.lsp.buf.code_action,
		desc = "Code Action",
		method = "textDocument/codeAction",
	},
	{ mode = "n", lhs = "<leader>ld", rhs = vim.diagnostic.open_float, desc = "Diagnostics" },
	{ mode = "n", lhs = "<leader>lr", rhs = vim.lsp.buf.rename, desc = "Rename", method = "textDocument/rename" },
	{ mode = "n", lhs = "K", rhs = vim.lsp.buf.hover, desc = "Hover", method = "textDocument/hover" },
	{
		mode = "n",
		lhs = "gd",
		rhs = picker.lsp_definitions,
		desc = "Go to Definition",
		method = "textDocument/definition",
	},
	{
		mode = "n",
		lhs = "gD",
		rhs = picker.lsp_declarations,
		desc = "Go to Declaration",
		method = "textDocument/declaration",
	},
	{ mode = "n", lhs = "gr", rhs = picker.lsp_references, desc = "References", method = "textDocument/references" },
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", { clear = true }),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local bufnr = args.buf

		for _, map in ipairs(mappings) do
			if not map.method or client:supports_method(map.method) then
				vim.keymap.set(map.mode, map.lhs, map.rhs, {
					buffer = bufnr,
					desc = map.desc,
					silent = true,
				})
			end
		end
	end,
})
