return {
	settings = {
		css = {
			lint = {
				-- for tailwind warnings
				unknownAtRules = "ignore",
			},
		},
	},
	capabilities = {
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = true,
				},
			},
		},
	},
}
