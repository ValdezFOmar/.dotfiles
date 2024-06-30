local function center_cursor()
    local window = vim.api.nvim_get_current_win()
    local height = vim.api.nvim_win_get_height(window)
    local line = math.ceil(height / 2)
    vim.api.nvim_win_set_cursor(window, { line, 0 })
end

local function toggle_cursorline()
    ---@diagnostic disable-next-line:undefined-field
    vim.opt_local.cursorline = not vim.opt_local.cursorline:get()
end

vim.opt_local.scrolloff = 999
vim.opt_local.cursorline = true
vim.opt_local.signcolumn = 'no'

vim.keymap.set('n', 's', toggle_cursorline, { buffer = true })

center_cursor()
