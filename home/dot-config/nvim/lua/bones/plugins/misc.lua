-- This is a special module for plugins that have small configurations
-- and thus, don't warrant a whole Lua module of its own.
-- This helps reducing the amount of files with 3-5 line plugin specs.

---@type LazyPluginSpec[]
return {
    { 'neovim/nvim-lspconfig' },
    {
        'stevearc/oil.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        lazy = false,
        keys = {
            { mode = 'n', '-', '<CMD>lua require("oil").open()<CR>' },
        },
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            columns = { 'icon', 'permissions' },
            watch_for_changes = true,
            skip_confirm_for_simple_edits = true,
            keymaps = {
                q = { mode = 'n', 'actions.close' },
            },
        },
    },
    -- Git wrapper
    { 'tpope/vim-fugitive', lazy = false },
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
        event = 'VeryLazy',
        version = '^4.0.0',
    },
    -- Lua LS config for neovim configuration
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        ---@module 'lazydev'
        ---@type lazydev.Config
        opts = {
            library = {
                'lazy.nvim',
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
            enabled = function(root)
                return not vim.uv.fs_stat(vim.fs.joinpath(root, '.luarc.json'))
            end,
        },
    },
    -- Autocomplete pairs parenthesis, brackets, quotes, etc.
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = { enable_check_bracket_line = false },
    },
    -- Fuzzy finder
    {
        'ibhagwan/fzf-lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        keys = {
            { mode = 'n', '<leader>ps', '<CMD>FzfLua grep<CR>', desc = 'Pick search' },
            { mode = 'n', '<leader>pf', '<CMD>FzfLua files<CR>', desc = 'Pick files' },
            { mode = 'n', '<leader>pg', '<CMD>FzfLua git_files<CR>', desc = 'Pick git files' },
            { mode = 'n', '<leader>pb', '<CMD>FzfLua buffers<CR>', desc = 'Pick buffers' },
        },
        opts = {
            winopts = {
                border = function()
                    return vim.o.winborder
                end,
                preview = {
                    border = function()
                        return vim.o.winborder
                    end,
                },
            },
        },
    },
}
