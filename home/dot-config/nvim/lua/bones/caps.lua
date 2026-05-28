local M = {}

local augroup = vim.api.nvim_create_augroup('bones.caps', {})
local caps_active = 'bones_caps_active'

---@param buf integer
local function disable(buf)
    vim.api.nvim_clear_autocmds { buf = buf, group = augroup }
    vim.b[buf][caps_active] = false
    vim.api.nvim_echo({ { 'caps off', 'DiagnosticInfo' } }, false, {})
end

function M.toggle()
    local buf = vim.api.nvim_get_current_buf()
    if vim.b[buf][caps_active] then
        disable(buf)
        return
    end
    -- NOTE: doesn't handle \r
    vim.api.nvim_create_autocmd('InsertCharPre', {
        buf = buf,
        group = augroup,
        callback = function()
            local char = vim.v.char
            if char == '-' or char == '_' then
                vim.v.char = '_'
            elseif vim.fn.match(char, [[\k]]) == 0 then
                vim.v.char = vim.fn.toupper(char)
            else
                disable(buf)
            end
        end,
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
        buf = buf,
        group = augroup,
        callback = function()
            disable(buf)
        end,
    })
    vim.b[buf][caps_active] = true
    vim.api.nvim_echo({ { 'caps on', 'DiagnosticWarn' } }, false, {})
end

return M
