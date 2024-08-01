local utils = require 'bones.utils'
local remap = vim.keymap.set

---Options for cmd keymaps
---@param desc string?
---@return vim.keymap.set.Opts
local function cmd_opts(desc)
    return { silent = true, desc = desc }
end

vim.g.mapleader = ' '

remap('n', '<leader><leader>', '<Cmd>Lazy<Enter>', cmd_opts())
remap('n', '<leader>ls', '<Cmd>Mason<Enter>', cmd_opts())
remap('n', '<leader>e', '<Cmd>Telescope file_browser<Enter>', cmd_opts())
remap('n', 'L', vim.diagnostic.open_float, { desc = 'See diagnostics' })
remap('n', '<leader>i', '<Cmd>Inspect<Enter>', cmd_opts 'Treesitter tokens')
remap('n', '<Esc>', '<Cmd>nohlsearch<Enter>', cmd_opts 'Remove search highlighting')
remap({ 'n', 'v', 'i' }, '<C-z>', '<Nop>', { desc = 'Prevents for accidentally suspending neovim' })

remap('n', '<C-a>', 'ggVG', { desc = 'Select all text' })
remap('x', '<leader>p', [["_dP]], { desc = 'Keep yanked text after pasting' })
remap('n', '<leader>Y', [["+Y]], { desc = 'Copy line to clipboard' })
remap('x', '<leader>Y', [["+y]], { desc = 'Copy selected text to clipboard' })
remap({ 'n', 'x' }, '<leader>P', [["+p]], { desc = 'Paste from clipboard' })
remap('n', '<leader>cb', '<Cmd>bdelete<Enter>', cmd_opts 'Close the current buffer')

remap('n', '<leader>w', '<Cmd>silent write<Enter>', cmd_opts 'Save current buffer')
remap('n', '<leader>q', '<Cmd>quit<Enter>', cmd_opts 'Quit Neovim')
remap('n', 'U', '<C-r>', { desc = 'Redo changes with U' })
remap('n', 'J', 'mzJ`z', { desc = "Same as `J`, but doesn't move the cursor" })
remap('i', '<C-a>', '<Esc>I', { desc = 'Move cursor to the start of line' })
remap('i', '<C-e>', '<Esc>A', { desc = 'Move cursor to the end of line' })

remap('n', '<S-Enter>', utils.trykey('O<Esc>0"_D', '<S-Enter>'), {
    expr = true,
    desc = 'Add new line above the cursor',
    noremap = true,
})
remap('n', '<Enter>', utils.trykey('o<Esc>0"_D', '<Enter>'), {
    expr = true,
    desc = 'Add new line under the cursor',
    noremap = true,
})

remap('n', '<Tab>', '>>', { desc = 'Add 1 level of indentation' })
remap('x', '<Tab>', '>gv', { desc = 'Add 1 level of indentation' })
remap('n', '<S-Tab>', '<<', { desc = 'Remove 1 level of indentation' })
remap('n', '<BS>', '<<', { desc = 'Remove 1 level of indentation' })
remap('x', '<S-Tab>', '<gv', { desc = 'Remove 1 level of indentation' })
remap('x', '<BS>', '<gv', { desc = 'Remove 1 level of indentation' })

remap('n', '<leader>xx', '<Cmd>!chmod u+x %<Enter>', cmd_opts 'Make file executable')
remap('n', 'gx', utils.uri.open, { desc = 'Open a URI' })

-- Moving between tabs
remap('n', '<M-h>', '<Cmd>tabprevious<Enter>', cmd_opts())
remap('n', '<M-l>', '<Cmd>tabnext<Enter>', cmd_opts())
remap('n', '<M-H>', '<Cmd>tabmove-<Enter>', cmd_opts())
remap('n', '<M-L>', '<Cmd>tabmove+<Enter>', cmd_opts())
