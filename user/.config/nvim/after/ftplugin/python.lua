vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

---@param cmd_name string
---@return function
local function on_exit(cmd_name)
    ---@param cmd vim.SystemCompleted
    return vim.schedule_wrap(function(cmd)
        if cmd.code == 0 then
            return
        end
        local name = cmd_name
        if cmd.stderr and cmd.stderr ~= '' then
            name = cmd_name .. '\n'
        end
        local msg = ('[exit: %d] %s%s'):format(cmd.code, name, cmd.stderr or '')
        vim.notify(msg, vim.log.levels.ERROR)
    end)
end

---@param cmd string[]
---@param name string
local function handle_cmd(cmd, name)
    local ok, process = pcall(vim.system, cmd, { text = true }, on_exit(name))
    if not ok then
        local message = ('could not run "%s", command failed: %s'):format(name, vim.inspect(cmd))
        vim.notify(message, vim.log.levels.ERROR)
    else
        process:wait(5000) -- milliseconds
    end
end

local function format_current_file()
    local filename = vim.fn.expand '%:p'
    if filename == '' then
        vim.notify('Failed to expand current filename', vim.log.levels.ERROR)
        return
    end
    if not vim.uv.fs_stat(filename) then
        vim.notify(("File %s doesn't exist"):format(filename), vim.log.levels.ERROR)
        return
    end
    vim.cmd.write { filename, mods = { silent = true } }
    handle_cmd({ 'ruff', 'format', filename }, 'ruff-format')
    handle_cmd({ 'ruff', 'check', '--select', 'I', '--fix', filename }, 'ruff')
    vim.cmd.edit { filename }
end

vim.keymap.set('n', '<leader>ff', format_current_file, { buffer = true })
