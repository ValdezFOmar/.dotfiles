local M = {}

---Install `lazy.nvim`
---@param path string Path for installation
---@return boolean `true` if `lazy.nvim` is installed
function M.install(path)
    if vim.uv.fs_stat(path) then
        return true
    end

    local command = {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        path,
    }
    local five_minutes = 5 * 60 * 1000 -- milliseconds
    local cmd = vim.system(command, { text = true }):wait(five_minutes)

    if cmd.code ~= 0 then
        vim.notify(
            ('Error installing lazy.nvim: [exit %d] %s'):format(cmd.code, cmd.stderr or ''),
            vim.log.levels.ERROR
        )
        return false
    end
    return true
end

return M
