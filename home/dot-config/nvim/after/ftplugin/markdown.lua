vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

if vim.bo.buftype == '' then
    vim.bo.textwidth = 72
    vim.wo[0][0].colorcolumn = '+1'

    vim.api.nvim_buf_create_user_command(0, 'Wrap', function()
        local wo = vim.wo[0][0]
        if wo.wrap then
            wo.wrap = false
            wo.colorcolumn = '+1'
        else
            wo.wrap = true
            wo.colorcolumn = ''
        end
    end, { desc = 'Toggle between a wrapping and non-wrapping mode' })
end

vim.keymap.set('n', 'j', 'gj', { buf = 0, desc = "Same as gj, convenient with 'wrap' option" })
vim.keymap.set('n', 'k', 'gk', { buf = 0, desc = "Same as gk, convenient with 'wrap' option" })
