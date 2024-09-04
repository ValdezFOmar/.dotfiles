local function toggle_cursorline()
    ---@diagnostic disable-next-line:undefined-field
    vim.opt_local.cursorline = not vim.opt_local.cursorline:get()
end

vim.opt_local.scrolloff = 999
vim.opt_local.cursorline = false
vim.opt_local.virtualedit = 'all'

vim.keymap.set('n', 's', toggle_cursorline, { buffer = true })

vim.defer_fn(function()
    local window = vim.api.nvim_get_current_win()
    local position = vim.api.nvim_win_get_cursor(window)
    vim.api.nvim_win_set_cursor(window, { position[1], 0 })
end, 10)
