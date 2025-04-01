vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

-- Disable line numbers in :InpectTree buffers
if vim.bo.buftype == 'nofile' then
    local winid = vim.api.nvim_get_current_win()
    local wo = vim.wo[winid][0]
    wo.number = false
    wo.relativenumber = false
    wo.signcolumn = 'no'
end
