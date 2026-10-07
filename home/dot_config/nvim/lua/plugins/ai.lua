vim.pack.add({
	"https://github.com/coder/claudecode.nvim",
})

require("claudecode").setup({})

require("which-key").add({
	{ "<leader>a", group = "ai" },
	{ "<leader>ac", "<CMD>ClaudeCode<CR>", desc = "Toggle Claude" },
	{ "<leader>af", "<CMD>ClaudeCodeFocus<CR>", desc = "Focus Claude" },
	{ "<leader>ar", "<CMD>ClaudeCode --resume<CR>", desc = "Resume Claude" },
	{ "<leader>am", "<CMD>ClaudeCodeSelectModel<CR>", desc = "Select Claude model" },
	{ "<leader>ab", "<CMD>ClaudeCodeAdd %<CR>", desc = "Add current buffer to Claude" },
	{ "<leader>as", "<CMD>ClaudeCodeSend<CR>", desc = "Send to Claude" },
	-- Diff management
	{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
	{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
})
