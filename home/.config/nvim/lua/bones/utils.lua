local M = {}

---@return boolean
local function current_buf_writeable()
    local buf = vim.api.nvim_get_current_buf()
    local buf_opts = vim.bo[buf]
    return buf_opts.modifiable and not buf_opts.readonly
end

---Use `key` if buffer can be modified, if not use `fallback`
---@param key string
---@param fallback string
---@return fun(): string
function M.trykey(key, fallback)
    return function()
        if not current_buf_writeable() then
            return fallback
        end
        return key
    end
end

---Handle opening a path
---@param path string Path to open
---@return string message Message to display
---@return boolean ok `false` if `message` is an error, `true` otherwise
local function do_open(path)
    local prefix = 'open: '
    local cmd, error = vim.ui.open(path)
    local process = cmd and cmd:wait(1000)

    if cmd and process and process.code ~= 0 then
        local status = (process.code == 124) and 'timeout' or 'failed'
        local command = vim.inspect(cmd.cmd)
        error = prefix .. ('command %s (%d): %s'):format(status, process.code, command)
    end

    if error then
        return error, false
    else
        return (prefix .. 'success: ' .. path), true
    end
end

M.uri = {
    filetypes = {}, ---@type table<string, fun(path: string): string?>
}

function M.uri.open()
    -- Strip common characters use for delimiting URLs
    local path = vim.fn.trim(vim.fn.expand '<cfile>', '⟨⟩')
    local message, ok = do_open(path)
    if ok then
        vim.notify(message, vim.log.levels.INFO)
        return
    end
    local func = M.uri.filetypes[vim.bo.filetype]
    if type(func) ~= 'function' then
        vim.notify(message, vim.log.levels.ERROR)
        return
    end
    local new_path = func(path)
    if not new_path then
        vim.notify(message, vim.log.levels.ERROR)
        return
    end
    message, ok = do_open(new_path)
    if not ok then
        vim.notify(message, vim.log.levels.ERROR)
        return
    end
    vim.notify(message, vim.log.levels.INFO)
end

function M.uri.filetypes.markdown()
    local buffer = vim.api.nvim_get_current_buf()
    local node = vim.treesitter.get_node { bufnr = buffer, ignore_injections = false }
    if not node then
        return
    end
    if node:type() == 'inline_link' then
        local link = node:named_child(1)
        if not (link and link:type() == 'link_destination') then
            return
        end
        return vim.treesitter.get_node_text(link, buffer)
    elseif node:type() == 'link_text' then
        local link = node:next_named_sibling()
        if not (link and link:type() == 'link_destination') then
            return
        end
        return vim.treesitter.get_node_text(link, buffer)
    elseif node:type() == 'email_autolink' then
        local email = vim.treesitter.get_node_text(node, buffer)
        return 'mailto:' .. vim.fn.trim(email, '<>')
    end
end

function M.uri.filetypes.lua(path)
    if path:match '^[^/]+/[^/]+$' then
        return 'https://github.com/' .. path
    end
end

return M
