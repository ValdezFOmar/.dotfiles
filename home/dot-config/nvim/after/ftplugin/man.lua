vim.wo[0][0].scrolloff = 999
vim.wo[0][0].cursorline = false

-- Position cursor in the middle (vertically) of the buffer
local height = math.min(vim.api.nvim_buf_line_count(0), vim.api.nvim_win_get_height(0))
local line = math.ceil(height / 2)
vim.api.nvim_win_set_cursor(0, { line, 0 })
