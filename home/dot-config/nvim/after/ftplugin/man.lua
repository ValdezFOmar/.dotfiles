local api = vim.api
local winid = api.nvim_get_current_win()
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
    local bufnr = api.nvim_win_get_buf(winid)
    local height = math.min(api.nvim_buf_line_count(bufnr), api.nvim_win_get_height(winid))
    local line = math.ceil(height / 2)
    api.nvim_win_set_cursor(winid, { line, 0 })
end
