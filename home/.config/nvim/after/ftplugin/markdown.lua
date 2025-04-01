vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

if vim.bo.buftype == '' then
    local winid = vim.api.nvim_get_current_win()
    local bo, wo = vim.bo, vim.wo[winid][0]
    bo.textwidth = 72
    wo.colorcolumn = '+1'
    wo.conceallevel = 2
    wo.concealcursor = 'nc'
end
