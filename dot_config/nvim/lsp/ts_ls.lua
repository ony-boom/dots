return {
	root_dir = function(bufnr, callback)
		local deno_dir = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
		local root_dir = vim.fs.root(bufnr, { "tsconfig.json", "jsconfig.json", "package.json" })

		if root_dir and deno_dir == nil then
			callback(root_dir)
		end
	end,
}
