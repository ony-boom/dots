return {
	root_dir = function(bufnr, callback)
		local root_dir = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })

		if root_dir then
			callback(root_dir)
		end
	end,
}
