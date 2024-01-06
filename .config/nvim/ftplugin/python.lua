vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.keymap.set("n", "<leader>r", "<cmd>!python %<Enter>", {
  buffer = 0, -- current buffer
  desc = "Run current python file."
})

-- group options prevents multiple executions.
-- See https://neovim.discourse.group/t/vimscript-autocmd-to-lua/2932
local py_group = vim.api.nvim_create_augroup("python_formatter", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Run formatter for python",
  group = py_group,
  command = "silent! !black %; isort %",
  buffer = 0,
})
