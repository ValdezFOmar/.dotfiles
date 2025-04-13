local winid = vim.api.nvim_get_current_win()
local wo = vim.wo[winid][0]

local function toggle_cursorline()
    wo.cursorline = not wo.cursorline
end

wo.scrolloff = 999
wo.cursorline = false
wo.virtualedit = 'all'

vim.keymap.set('n', 's', toggle_cursorline, { buffer = true })
