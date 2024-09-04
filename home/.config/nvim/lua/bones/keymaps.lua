local utils = require 'bones.utils'
local map = vim.keymap.set

---Options for cmd keymaps
---@param desc string?
---@return vim.keymap.set.Opts
local function cmd_opts(desc)
    return { silent = true, desc = desc }
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

map('n', '<leader><leader>', '<Cmd>Lazy<Enter>', cmd_opts())
map('n', '<leader>ls', '<Cmd>Mason<Enter>', cmd_opts())
map('n', '<leader>e', '<Cmd>Telescope file_browser<Enter>', cmd_opts())
map('n', 'L', vim.diagnostic.open_float, { desc = 'See diagnostics' })
map('n', '<leader>i', '<Cmd>Inspect<Enter>', cmd_opts 'Treesitter tokens')
map('n', '<Esc>', '<Cmd>nohlsearch<Enter>', cmd_opts 'Remove search highlighting')
map({ 'n', 'v', 'i' }, '<C-z>', '<Nop>', { desc = 'Prevents for accidentally suspending neovim' })

map('n', '<C-a>', 'ggVG', { desc = 'Select all text' })
map('x', '<leader>p', [["_dP]], { desc = 'Keep yanked text after pasting' })
map('n', '<leader>Y', [["+Y]], { desc = 'Copy line to clipboard' })
map('x', '<leader>Y', [["+y]], { desc = 'Copy selected text to clipboard' })
map({ 'n', 'x' }, '<leader>P', [["+p]], { desc = 'Paste from clipboard' })
map('n', '<leader>cb', '<Cmd>bdelete<Enter>', cmd_opts 'Close the current buffer')

map('n', '<leader>w', '<Cmd>silent write<Enter>', cmd_opts 'Save current buffer')
map('n', '<leader>q', '<Cmd>quit<Enter>', cmd_opts 'Quit Neovim')
map('n', 'U', '<C-r>', { desc = 'Redo changes with U' })
map('n', 'J', 'mzJ`z', { desc = "Same as `J`, but doesn't move the cursor" })
map('i', '<C-a>', '<Esc>I', { desc = 'Move cursor to the start of line' })
map('i', '<C-e>', '<Esc>A', { desc = 'Move cursor to the end of line' })

map('n', '<S-Enter>', utils.trykey('O<Esc>0"_D', '<S-Enter>'), {
    expr = true,
    desc = 'Add new line above the cursor',
    noremap = true,
})
map('n', '<Enter>', utils.trykey('o<Esc>0"_D', '<Enter>'), {
    expr = true,
    desc = 'Add new line under the cursor',
    noremap = true,
})

map('n', '<Tab>', '>>', { desc = 'Add 1 level of indentation' })
map('x', '<Tab>', '>gv', { desc = 'Add 1 level of indentation' })
map('n', '<S-Tab>', '<<', { desc = 'Remove 1 level of indentation' })
map('n', '<BS>', '<<', { desc = 'Remove 1 level of indentation' })
map('x', '<S-Tab>', '<gv', { desc = 'Remove 1 level of indentation' })
map('x', '<BS>', '<gv', { desc = 'Remove 1 level of indentation' })

map('n', '<leader>xx', '<Cmd>!chmod u+x %<Enter>', cmd_opts 'Make file executable')
map('n', 'gx', utils.uri.open, { desc = 'Open a URI' })

-- Moving between tabs
map('n', '<M-h>', '<Cmd>tabprevious<Enter>', cmd_opts())
map('n', '<M-l>', '<Cmd>tabnext<Enter>', cmd_opts())
map('n', '<M-H>', '<Cmd>tabmove-<Enter>', cmd_opts())
map('n', '<M-L>', '<Cmd>tabmove+<Enter>', cmd_opts())
