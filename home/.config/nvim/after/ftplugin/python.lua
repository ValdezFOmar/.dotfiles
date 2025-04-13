local fn = vim.fn
local uv = vim.uv
local log = vim.log.levels
local notify = vim.notify
local wrap = vim.schedule_wrap

---@param cmd string[]
local function run(cmd)
    ---@param out vim.SystemCompleted
    local on_exit = wrap(function(out)
        if out.code == 0 then
            return
        end
        local command = table.concat(cmd, ' ')
        if out.stderr and out.stderr ~= '' then
            command = command .. '\n'
        end
        local msg = ('[exit: %d] %s%s'):format(out.code, command, out.stderr or '')
        notify(msg, log.ERROR)
    end)
    local ok, process = pcall(vim.system, cmd, { text = true }, on_exit)
    if not ok then
        notify('could not run "' .. cmd[0] .. '", command not found', log.ERROR)
    else
        process:wait(5000) -- milliseconds
    end
end

local function format_current_file()
    local filename = fn.expand '%:p'
    if filename == '' then
        notify('Failed to expand current filename', log.ERROR)
        return
    end
    if not uv.fs_stat(filename) then
        notify("File '" .. filename .. "' doesn't exist", log.ERROR)
        return
    end
    vim.cmd.write { filename, mods = { silent = true } }
    run { 'ruff', 'format', filename }
    run { 'ruff', 'check', '--select', 'I', '--fix', filename }
    vim.cmd.edit { filename }
end

vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

vim.keymap.set('n', '<F3>', format_current_file, { buffer = true })
