local set = vim.opt
local keymap = vim.keymap.set

set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.expandtab = true

-- Run linter for current file
keymap("n", "<leader>lf", "<cmd>!djlint %<Enter>", { buffer = true })

vim.api.nvim_create_autocmd(
  "BufWritePost",
  {
    pattern = "*.html",
    command = "silent! !djlint --reformat %",
    group = vim.api.nvim_create_augroup("template_formatter", { clear = true }),
    desc = "Run formatter for django templates",
  }
)
