vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.keymap.set("n", "<leader>r", "<cmd>!python %<Enter>", {
  buffer = 0, -- current buffer
  desc = "Run current python file.",
})

vim.keymap.set("n", "<leader>ff", function()
  vim.cmd [[
    silent !isort %
    silent !black %
  ]]
end, {
  buffer = 0, -- current buffer
  desc = "Format curretn file.",
})
