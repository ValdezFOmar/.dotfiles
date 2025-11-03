local M = {}

local augroup = vim.api.nvim_create_augroup('bones.caps', {})

---@param bufnr integer
local function disable(bufnr)
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.b[bufnr].bones_caps_enabled = false
    vim.api.nvim_echo({ { 'caps off', 'DiagnosticInfo' } }, false, {})
end

function M.toggle()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.b[bufnr].bones_caps_enabled then
        disable(bufnr)
        return
    end
    -- NOTE: doesn't handle \r
    vim.api.nvim_create_autocmd('InsertCharPre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
            local char = vim.v.char
            if char == '-' or char == '_' then
                vim.v.char = '_'
            elseif vim.fn.match(char, '\\k') == 0 then
                vim.v.char = vim.fn.toupper(char)
            else
                disable(bufnr)
            end
        end,
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
        group = augroup,
        buffer = bufnr,
        callback = function()
            disable(bufnr)
        end,
    })
    vim.b[bufnr].bones_caps_enabled = true
    vim.api.nvim_echo({ { 'caps on', 'DiagnosticWarn' } }, false, {})
end

return M
