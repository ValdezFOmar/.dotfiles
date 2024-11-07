local M = {}
local data_path = vim.fn.stdpath 'data' --[[@as string]]
local lazy_path = vim.fs.joinpath(data_path, 'lazy', 'lazy.nvim')

---Install `lazy.nvim`
---@param path string? Path for installation
---@return boolean `true` if `lazy.nvim` is installed
function M.install(path)
    path = path or lazy_path

    if vim.uv.fs_stat(path) then
        vim.opt.rtp:prepend(path)
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
    else
        vim.opt.rtp:prepend(path)
        return true
    end
end

return M
