vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

---@param cmd string[]
local function run(cmd)
    local ok, process = pcall(
        vim.system,
        cmd,
        { text = true },
        ---@param p vim.SystemCompleted
        vim.schedule_wrap(function(p)
            if p.code == 0 then
                return
            end
            local command = table.concat(cmd, ' ')
            if p.stderr and p.stderr ~= '' then
                command = command .. '\n'
            end
            local msg = ('[exit: %d] %s%s'):format(p.code, command, p.stderr or '')
            vim.notify(msg, vim.log.levels.ERROR)
        end)
    )

    if not ok then
        vim.notify('could not run "' .. cmd[0] .. '", command not found', vim.log.levels.ERROR)
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
        vim.notify(("File '%s' doesn't exist"):format(filename), vim.log.levels.ERROR)
        return
    end
    vim.cmd.write { filename, mods = { silent = true } }
    run { 'ruff', 'format', filename }
    run { 'ruff', 'check', '--select', 'I', '--fix', filename }
    vim.cmd.edit { filename }
end

vim.keymap.set('n', '<F3>', format_current_file, { buffer = true })
