local winid = vim.api.nvim_get_current_win()
local wo = vim.wo[winid][0]

local function toggle_cursorline()
    wo.cursorline = not wo.cursorline
end

wo.scrolloff = 999
wo.cursorline = false
wo.signcolumn = 'no'
wo.spell = false

vim.keymap.set('n', 's', toggle_cursorline, { buffer = true })

-- Position cursor in the middle (vertically) of the buffer
do
    local buffer = vim.api.nvim_win_get_buf(winid)
    local window_height = vim.api.nvim_win_get_height(winid)
    local buffer_height = vim.api.nvim_buf_line_count(buffer)
    local height = (buffer_height < window_height) and buffer_height or window_height
    local line = math.ceil(height / 2)
    vim.api.nvim_win_set_cursor(winid, { line, 0 })
end
