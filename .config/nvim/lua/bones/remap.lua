local keymap = vim.keymap.set

vim.g.mapleader = " "
keymap("n", "<leader>e", vim.cmd.Ex)

-- Make file executable
keymap("n", "<leader>x", "<cmd>!chmod u+x %<Enter>", { silent = true })

-- Paste line to clipboard
keymap("n", "<leader>Y", [["+Y]])

-- Paste selected text to clipboard
keymap("v", "<leader>Y", [["+y]])

-- Add new line under the cursor
keymap("n", "<Enter>", "o<Esc>0d$")

-- Add new line above the cursor
keymap("n", "<S-Enter>", "O<Esc>0d$")

-- Revert changes with U
keymap("n", "U", "<C-r>")

-- Add 1 level of indentation
keymap("n", "<Tab>", ">>")
keymap("v", "<Tab>", ">gv")

-- Remove 1 level of indentation
keymap("n", "<S-Tab>", "<<")
keymap("v", "<S-Tab>", "<gv")
keymap("v", "<BS>", "<gv")
