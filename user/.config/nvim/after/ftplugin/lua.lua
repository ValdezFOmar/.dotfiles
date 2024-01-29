vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

local group = vim.api.nvim_create_augroup("lua_formatter", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Run formatter for lua",
  group = group,
  callback = function()
    vim.lsp.buf.format()
  end,
  buffer = 0,
})
