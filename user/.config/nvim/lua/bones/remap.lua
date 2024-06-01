---@return boolean
local function current_buf_writeable()
    local buf = vim.api.nvim_get_current_buf()
    local buf_opts = vim.bo[buf]
    return buf_opts.modifiable and not buf_opts.readonly
end

---@param key string
---@param fallback string
---@return string
local function trykey(key, fallback)
    if not current_buf_writeable() then
        return fallback
    end
    return key
end

---Options for cmd keymaps
---@param desc string|nil
---@return table
local function cmd_opts(desc)
    return {
        silent = true,
        noremap = true,
        desc = desc or '',
    }
end

vim.g.mapleader = ' '

local remap = vim.keymap.set
remap('n', '<leader><leader>', '<Cmd>Lazy<Enter>', cmd_opts())
remap('n', '<leader>ls', '<Cmd>Mason<Enter>', cmd_opts())
remap('n', '<leader>e', '<Cmd>Telescope file_browser<Enter>', cmd_opts())
remap('n', 'L', function()
    vim.diagnostic.open_float()
end, { desc = 'See diagnostics' })
remap('n', '<leader>i', '<Cmd>Inspect<Enter>', cmd_opts 'Treesitter tokens')
remap('n', '<leader>nh', '<Cmd>noh<Enter>', cmd_opts 'Remove search highlighting')
remap({ 'n', 'v', 'i' }, '<C-z>', '<Nop>', { desc = 'Prevents for accidentally suspending neovim' })

remap('n', '<C-a>', 'ggVG', { desc = 'Select all text' })
remap('x', '<leader>p', [["_dP]], { desc = 'Keep yanked text after pasting' })
remap('n', '<leader>Y', [["+Y]], { desc = 'Copy line to clipboard' })
remap('v', '<leader>Y', [["+y]], { desc = 'Copy selected text to clipboard' })
remap({ 'n', 'v' }, '<leader>P', [["+p]], { desc = 'Paste from clipboard' })
remap('n', '<leader>cb', '<Cmd>bdelete<Enter>', cmd_opts 'Close the current buffer')

remap('n', '<leader>w', '<Cmd>silent write<Enter>', cmd_opts 'Save current buffer')
remap('n', '<leader>q', '<Cmd>quit<Enter>', cmd_opts 'Quit Neovim')
remap('n', 'U', '<C-r>', { desc = 'Redo changes with U' })
remap('n', 'J', 'mzJ`z', { desc = "Same as `J`, but doesn't move the cursor" })
remap('i', '<C-a>', '<Esc>I', { desc = 'Move cursor to the start of line' })
remap('i', '<C-e>', '<Esc>A', { desc = 'Move cursor to the end of line' })
remap('n', '<leader>0', '^', { desc = 'Move to first non whitespace char' })

remap('n', '<S-Enter>', function()
    return trykey([[O<Esc>0"_D]], '<S-Enter>')
end, {
    expr = true,
    desc = 'Add new line above the cursor',
    noremap = true,
})
remap('n', '<Enter>', function()
    return trykey([[o<Esc>0"_D]], '<Enter>')
end, {
    expr = true,
    desc = 'Add new line under the cursor',
    noremap = true,
})

remap('n', '<Tab>', '>>', { desc = 'Add 1 level of indentation' })
remap('v', '<Tab>', '>gv', { desc = 'Add 1 level of indentation' })
remap('n', '<S-Tab>', '<<', { desc = 'Remove 1 level of indentation' })
remap('n', '<BS>', '<<', { desc = 'Remove 1 level of indentation' })
remap('v', '<S-Tab>', '<gv', { desc = 'Remove 1 level of indentation' })
remap('v', '<BS>', '<gv', { desc = 'Remove 1 level of indentation' })

remap('n', '<leader>xx', '<Cmd>!chmod u+x %<Enter>', cmd_opts 'Make file executable')

-- Moving between tabs
remap('n', '<M-h>', '<Cmd>tabprevious<Enter>', cmd_opts())
remap('n', '<M-l>', '<Cmd>tabnext<Enter>', cmd_opts())
remap('n', '<M-H>', '<Cmd>tabmove-<Enter>', cmd_opts())
remap('n', '<M-L>', '<Cmd>tabmove+<Enter>', cmd_opts())
