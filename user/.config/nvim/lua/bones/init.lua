-- Load settings before loading lazy
require 'bones.keymaps'
require 'bones.settings'
require 'bones.commands'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
    vim.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('bones.plugins', {
    rocks = { enabled = false },
    install = {
        colorscheme = { 'catppuccin-mocha', 'default' },
    },
    ui = {
        title = 'lazy.nvim 󰒲 ',
        border = 'rounded',
    },
    checker = {
        enabled = true,
        concurrency = 1,
        notify = false,
    },
    -- This creates an annoying prompt in all neovim instances
    change_detection = {
        enabled = false,
        notify = false,
    },
})
