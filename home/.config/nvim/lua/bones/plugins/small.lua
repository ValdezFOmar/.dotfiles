-- This is a special module for plugins that have small configurations
-- and thus, don't warrant a whole Lua module of its own.
-- This helps reducing the amount of files with 3-5 line plugin specs.

---@type LazyPluginSpec[]
return {
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
        version = '*',
        lazy = false,
        config = true,
    },
    -- Lua LS config for neovim configuration
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
        },
    },
    -- Types for vim.uv, used by lazydev
    { 'Bilal2453/luvit-meta', lazy = true },
    -- Autocomplete pairs parenthesis, brackets, quotes, etc.
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup { enable_check_bracket_line = false }
            local cmp = require 'cmp'
            local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
            -- If you want to insert `(` after the selected function or method item
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { filetypes = { sh = false } })
        end,
    },
}
