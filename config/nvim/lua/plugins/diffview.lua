return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
		{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
		{ "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview Current File History" },
		{ "<leader>gl", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History" },
	},
	opts = {},
}
