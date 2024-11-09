local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd({ 'BufNewFile', 'BufRead' }, {
    group = augroup('InsertBlankLineMappings', {}),
    callback = function(event)
        if vim.fn.getcmdwintype() ~= '' then
            return -- Don't override <Enter> mappings when editing commands
        end
        ---@type integer
        local bufnr = event.buf
        local bo = vim.bo[bufnr]
        if not bo.modifiable or bo.readonly then
            return
        end
        map('n', '<S-Enter>', 'mzO<Esc>0"_D`z', { buffer = bufnr, desc = 'Blank line above' })
        map('n', '<Enter>', 'mzo<Esc>0"_D`z', { buffer = bufnr, desc = 'Blank line below' })
    end,
})
