local api = vim.api
local fn = vim.fn
local ts = vim.treesitter

local M = {}

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

-- Characters commonly use for delimiting URLs
local delimiters = '⟨⟩'

---Open `text` using `vim.ui.open`.
---Open `<cfile>` when `text` is `nil`.
---@param text string?
function M.open(text)
    text = text or fn.expand '<cfile>'
    local path = fn.trim(text, delimiters)
    local message, ok = do_open(path)
    if ok then
        vim.notify(message, vim.log.levels.INFO)
        return
    end
    local func = M.filetypes[vim.bo.filetype]
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

---@type table<string, fun(path: string): string?>
M.filetypes = {}

function M.filetypes.markdown()
    local bufnr = api.nvim_get_current_buf()
    local node = ts.get_node { bufnr = bufnr, ignore_injections = false }
    if not node then
        return
    end
    local node_name = node:type()
    if node_name == 'inline_link' then
        local link = node:named_child(1)
        if not link or link:type() ~= 'link_destination' then
            return
        end
        return ts.get_node_text(link, bufnr)
    elseif node_name == 'link_text' then
        local link = node:next_named_sibling()
        if not link or link:type() ~= 'link_destination' then
            return
        end
        return ts.get_node_text(link, bufnr)
    elseif node_name == 'email_autolink' then
        local email = ts.get_node_text(node, bufnr)
        return 'mailto:' .. fn.trim(email, '<>')
    end
end

function M.filetypes.lua(path)
    if path:match '^[^/]+/[^/]+$' then
        return 'https://github.com/' .. path
    end
end

return M
