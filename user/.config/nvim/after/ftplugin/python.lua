vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

vim.keymap.set("n", "<leader>r", [[:TermExec cmd="python %"<Return>]], {
  buffer = 0, -- current buffer
  desc = "Run current python file.",
  silent = true,
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
