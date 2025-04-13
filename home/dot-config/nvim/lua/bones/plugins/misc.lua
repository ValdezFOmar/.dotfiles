-- This is a special module for plugins that have small configurations
-- and thus, don't warrant a whole Lua module of its own.
-- This helps reducing the amount of files with 3-5 line plugin specs.

---@type LazyPluginSpec[]
return {
    -- Git wrapper
    { 'tpope/vim-fugitive', lazy = false },
    -- Kitty syntax highlighting
    { 'fladson/vim-kitty', ft = 'kitty' },
    -- Nice look for neovim native tabs (icons, short filename, etc.)
    {
        'alvarosevilla95/luatab.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = true,
    },
    -- Surround with parenthesis, brackets, quotes, etc.
    -- :h nvim-surround.usage
    {
        'kylechui/nvim-surround',
        version = '^3.0.0',
        event = 'VeryLazy',
        config = true,
    },
    -- Lua LS config for neovim configuration
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                'lazy.nvim',
                'luvit-meta/library',
            },
        },
    },
    -- Types for vim.uv, used by lazydev
    { 'Bilal2453/luvit-meta', lazy = true },
    -- A better way of writing SNAKE_CASE_CONSTANTS
    {
        'dmtrKovalenko/caps-word.nvim',
        lazy = true,
        opts = {},
        keys = {
            {
                mode = 'i',
                '<C-s>',
                '<cmd>lua require("caps-word").toggle()<CR>',
            },
        },
    },
    -- Autocomplete pairs parenthesis, brackets, quotes, etc.
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup { enable_check_bracket_line = false }
            local cmp = require 'cmp'
            local cmp_ap = require 'nvim-autopairs.completion.cmp'
            -- If you want to insert `(` after the selected function or method item
            cmp.event:on('confirm_done', cmp_ap.on_confirm_done { filetypes = { sh = false } })
        end,
    },
}
