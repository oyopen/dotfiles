return {
	dir = vim.fn.expand("~/ghq/github.com/sansaninc/auth-one/neovim/auth-kun.nvim"),
	cond = function()
		local repo = vim.fn.expand("~/ghq/github.com/sansaninc/auth-one")
		local cwd = vim.fn.getcwd()
		return cwd == repo or vim.startswith(cwd, repo .. "/")
	end,
	config = function()
		require("auth-kun").setup()
	end,
}
