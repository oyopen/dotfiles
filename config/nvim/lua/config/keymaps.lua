vim.keymap.set("n", "<leader><space>", LazyVim.pick("files", { root = false }), { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>ff", LazyVim.pick("files", { root = false }), { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>fF", LazyVim.pick("files"), { desc = "Find Files (Root Dir)" })

vim.keymap.set("n", "<leader>/", LazyVim.pick("grep", { root = false }), { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sg", LazyVim.pick("live_grep", { root = false }), { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sG", LazyVim.pick("live_grep"), { desc = "Grep (Root Dir)" })
