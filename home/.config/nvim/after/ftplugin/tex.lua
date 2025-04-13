vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.bo.textwidth = 80

local winid = vim.api.nvim_get_current_win()
vim.wo[winid][0].colorcolumn = '+1'
