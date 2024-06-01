-- Consider moving this configuration to a autocommand
-- so it can be applied to both manpages and vim help pages
-- also consider setting:
-- vim.opt_local.signcolumn = 'yes:9' in vim help files but
-- not in manpages since that will break the formatting
-- set the options one in the autocommand by setting a buffer
-- variable `:help vim.b`
vim.opt_local.scrolloff = 999
vim.opt_local.cursorline = true
vim.opt_local.signcolumn = 'no'

vim.keymap.set('n', 's', function()
    vim.opt_local.cursorline = not vim.opt_local.cursorline:get()
end, { buffer = true, desc = 'Toggle visible cursorline' })

local line = math.ceil(vim.fn.winheight(0) / 2)
vim.fn.cursor { line, 1 }
