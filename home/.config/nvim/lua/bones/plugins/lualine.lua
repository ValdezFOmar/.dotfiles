local PLUGIN = { 'nvim-lualine/lualine.nvim' }

PLUGIN.dependencies = { 'nvim-tree/nvim-web-devicons' }

function PLUGIN.config()
    local custom_theme = require 'lualine.themes.catppuccin'
    local colors = require('catppuccin.palettes').get_palette 'mocha'
    local lazy_status = require 'lazy.status'

    local lazy_status_line = {
        lazy_status.updates,
        cond = lazy_status.has_updates,
        color = { fg = colors.peach },
    }

    custom_theme.normal.b.bg = colors.mantle
    custom_theme.insert.b.bg = colors.mantle
    custom_theme.terminal.b.bg = colors.mantle
    custom_theme.command.b.bg = colors.mantle
    custom_theme.visual.b.bg = colors.mantle
    custom_theme.replace.b.bg = colors.mantle
    custom_theme.inactive.b.bg = colors.mantle

    custom_theme.normal.c.bg = colors.surface0
    custom_theme.inactive.c.bg = colors.surface0

    require('lualine').setup {
        options = {
            theme = custom_theme,
            component_separators = { left = '│', right = '│' },
        },
        sections = {
            lualine_a = { 'mode', 'selectioncount' },
            lualine_b = { { 'branch', icon = '󰊢' }, 'diff' },
            lualine_c = {
                {
                    'filename',
                    path = 1,
                    symbols = {
                        modified = '',
                        readonly = '󰌾',
                        newfile = '󰎔',
                    },
                },
            },
            lualine_x = { 'diagnostics', lazy_status_line },
            lualine_y = {
                {
                    'filetype',
                    icon = { align = 'right' },
                    padding = { left = 1, right = 2 },
                },
            },
            lualine_z = { 'progress', 'location' },
        },
        extensions = { 'fzf', 'lazy', 'mason' },
    }
    vim.o.showmode = false
end

return PLUGIN
