vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- Make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- Paste to clipboard
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])
