vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

-- Disable line numbers in :InpectTree buffers
if vim.bo.buftype == 'nofile' then
    vim.wo[0][0].number = false
    vim.wo[0][0].relativenumber = false
end
