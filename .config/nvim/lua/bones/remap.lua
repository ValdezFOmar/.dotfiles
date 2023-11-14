local keymap = vim.keymap.set

vim.g.mapleader = " "
keymap("n", "<leader>e", vim.cmd.Ex)

keymap("n", "<leader>g", "<C-]>")

-- Prevents for accidentally suspending neovim
keymap({ "n", "v", "i" }, "<C-z>", "<Nop>")

-- Make file executable
keymap("n", "<leader>x", "<cmd>!chmod u+x %<Enter>", { silent = true })

-- Paste line to clipboard
keymap("n", "<leader>Y", [["+Y]])

-- Paste selected text to clipboard
keymap("v", "<leader>Y", [["+y]])

-- Select all text
keymap("n", "<C-a>", "ggVG")

-- Add new line under the cursor
keymap("n", "<leader><Enter>", "o<Esc>0d$")

-- Add new line above the cursor
keymap("n", "<S-Enter>", "O<Esc>0d$")

-- Redo changes with U
keymap("n", "U", "<C-r>")

-- Add 1 level of indentation
keymap("n", "<Tab>", ">>")
keymap("v", "<Tab>", ">gv")

-- Remove 1 level of indentation
keymap("n", "<S-Tab>", "<<")
keymap("n", "<BS>", "<<")
keymap("v", "<S-Tab>", "<gv")
keymap("v", "<BS>", "<gv")
