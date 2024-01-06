vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

local group = vim.api.nvim_create_augroup("lua_formatter", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Run formatter for lua",
  group = group,
  callback = function() vim.lsp.buf.format() end,
  buffer = 0,
})
