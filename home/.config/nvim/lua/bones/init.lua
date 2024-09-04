-- Load settings before loading lazy
require 'bones.keymaps'
require 'bones.settings'
require 'bones.commands'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
    local cmd = vim.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }, { text = true }):wait(5 * 60 * 1000) -- 5 minutes

    if cmd.code ~= 0 then
        vim.notify(
            ('Error installing lazy.nvim: [exit %d] %s'):format(cmd.code, cmd.stderr or ''),
            vim.log.levels.ERROR
        )
        return
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('bones.plugins', {
    rocks = { enabled = false },
    git = { cooldown = 60 * 5 },
    install = {
        colorscheme = { 'catppuccin-mocha', 'default' },
    },
    ui = {
        title = 'lazy.nvim 󰒲 ',
        border = 'rounded',
    },
    checker = {
        enabled = true,
        concurrency = 4,
        notify = false,
    },
    -- This avoids an annoying prompt in all neovim instances
    change_detection = {
        enabled = false,
        notify = false,
    },
})
