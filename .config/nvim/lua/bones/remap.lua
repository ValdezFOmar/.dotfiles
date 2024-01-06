---@return boolean
local function current_buf_writeable()
  local buf = vim.api.nvim_get_current_buf()
  local buf_opts = vim.bo[buf]
  return buf_opts.modifiable and not buf_opts.readonly
end

---@param key string
---@param fallback string
---@return string
local function trykey(key, fallback)
  if not current_buf_writeable() then
    return fallback
  end
  return key
end

local function ExCWD()
  vim.cmd.Ex(vim.fn.getcwd())
end

vim.g.mapleader = " "

local remap = vim.keymap.set
remap("n", "<leader><leader>", "<Cmd>Lazy<Enter>", { silent = true })
remap("n", "<leader>ls", "<Cmd>Mason<Enter>", { silent = true })
remap("n", "<leader>e", vim.cmd.Ex, { desc = "Vim Explorer" })
remap("n", "<leader>d", ExCWD, { desc = "Open explorer in root directory" })
remap("n", "<leader>g", "<C-]>", { desc = "Navigate to content in vim `:help topic`" })
remap("n", "<leader>i", "<Cmd>Inspect<Enter>")
remap("n", "<leader>nh", "<Cmd>noh<Enter>", { desc = "Remove search highlighting" })
remap({ "n", "v", "i" }, "<C-z>", "<Nop>", { desc = "Prevents for accidentally suspending neovim" })

remap("n", "<C-a>", "ggVG", { desc = "Select all text" })
remap("x", "<leader>p", [["_dP]], { desc = "Keep yanked text after pasting" })
remap("n", "<leader>Y", [["+Y]], { desc = "Copy line to clipboard" })
remap("v", "<leader>Y", [["+y]], { desc = "Copy selected text to clipboard" })
remap({ "n", "v" }, "<leader>P", [["+p]], { desc = "Paste from clipboard" })

remap("n", "<leader>w", "<Cmd>w<Enter>", { desc = "Save current buffer" })
remap("n", "<M-q>", "<Cmd>q<Enter>", { desc = "Quit Neovim" })
remap("n", "U", "<C-r>", { desc = "Redo changes with U" })
remap("n", "J", "mzJ`z", { desc = "Same as `J`, but doesn't move the cursor" })

remap("n", "<S-Enter>", function() return trykey("O<Esc>0D", "<S-Enter") end,
  { expr = true, desc = "Add new line above the cursor" })
remap("n", "<Enter>", function() return trykey("o<Esc>0D", "<Enter>") end,
  { expr = true, desc = "Add new line under the cursor" })

remap("n", "<Tab>", ">>", { desc = "Add 1 level of indentation" })
remap("v", "<Tab>", ">gv", { desc = "Add 1 level of indentation" })
remap("n", "<S-Tab>", "<<", { desc = "Remove 1 level of indentation" })
remap("n", "<BS>", "<<", { desc = "Remove 1 level of indentation" })
remap("v", "<S-Tab>", "<gv", { desc = "Remove 1 level of indentation" })
remap("v", "<BS>", "<gv", { desc = "Remove 1 level of indentation" })

remap("n", "<leader>x", "<Cmd>!chmod u+x %<Enter>", { desc = "Make file executable", silent = true })


-- barbar.nvim keymaps
local barbar_opts = { silent = true, noremap = true }
remap("n", "<M-h>", "<Cmd>BufferPrevious<Enter>", barbar_opts)
remap("n", "<M-l>", "<Cmd>BufferNext<Enter>", barbar_opts)
remap('n', '<leader>q', '<Cmd>BufferClose<Enter>', barbar_opts)
remap('n', '<leader>s', '<Cmd>BufferPick<Enter>', barbar_opts)
-- Goto buffer in position...
remap('n', '<M-1>', '<Cmd>BufferGoto 1<Enter>', barbar_opts)
remap('n', '<M-2>', '<Cmd>BufferGoto 2<Enter>', barbar_opts)
remap('n', '<M-3>', '<Cmd>BufferGoto 3<Enter>', barbar_opts)
remap('n', '<M-4>', '<Cmd>BufferGoto 4<Enter>', barbar_opts)
remap('n', '<M-5>', '<Cmd>BufferGoto 5<Enter>', barbar_opts)
remap('n', '<M-6>', '<Cmd>BufferGoto 6<Enter>', barbar_opts)
remap('n', '<M-7>', '<Cmd>BufferGoto 7<Enter>', barbar_opts)
remap('n', '<M-8>', '<Cmd>BufferGoto 8<Enter>', barbar_opts)
remap('n', '<M-9>', '<Cmd>BufferGoto 9<Enter>', barbar_opts)
remap('n', '<M-0>', '<Cmd>BufferLast<Enter>', barbar_opts)
