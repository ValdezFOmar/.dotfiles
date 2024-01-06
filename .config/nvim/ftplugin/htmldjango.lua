
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Run linter for current file
vim.keymap.set("n", "<leader>lf", "<cmd>!djlint %<Enter>", { buffer = 0 })

local group = vim.api.nvim_create_augroup("template_formatter", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Run formatter for django templates",
  command = "silent! !djlint --reformat %",
  group = group,
  buffer = 0,
})
