local PLUGIN = { 'catppuccin/nvim' }

PLUGIN.name = 'catppuccin'
PLUGIN.lazy = false
PLUGIN.priority = 1000

function PLUGIN.config(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
end

---@type CatppuccinOptions
PLUGIN.opts = {
    flavor = 'mocha',
    background = { dark = 'mocha' },
    transparent_background = true,
    show_end_of_buffer = true,
    styles = {
        conditionals = { 'italic' },
        loops = { 'italic' },
        keywords = { 'italic' },
    },
    custom_highlights = function(colors)
        local builtin = '#7d7ddb' -- Original builtin #8888C6
        local documentation = '#71a162'
        return {
            ['@lsp.type.comment'] = {}, -- Disabled because it overrides usefull highlighting
            -- General config
            ['@constant.builtin'] = { fg = colors.pink, style = {} },
            ['@variable.builtin'] = { style = { 'italic' } },
            ['@module.builtin'] = { link = '@variable.builtin' },
            ['@keyword.operator'] = { link = 'Keyword' },
            ['@keyword.conditional.ternary'] = { link = 'Operator' },
            ['@attribute'] = { fg = colors.green },
            ['@attribute.builtin'] = { link = '@attribute' },
            ['@lsp.type.decorator'] = { link = '@attribute' },
            ['@attribute.diff'] = { fg = colors.sapphire },
            ['@function.builtin'] = { fg = builtin },
            ['@function.builtin.bash'] = { fg = builtin, style = {} },
            ['@string.documentation'] = { fg = documentation },
            -- markup
            ['@markup.quote'] = { fg = colors.mauve },
            ['@markup.link.url'] = { style = { 'underline' } },
            ['@string.special.url'] = { style = { 'underline' } },
            ['@markup.link.vimdoc'] = { fg = colors.mauve, style = { 'underline' } },
            -- SQL
            ['@keyword.sql'] = { fg = colors.mauve },
            ['@keyword.operator.sql'] = { fg = colors.mauve },
            -- HTML
            ['@tag.delimiter'] = { link = 'Delimiter' },
            ['@punctuation.bracket.htmldjango'] = { fg = colors.pink },
            -- GUI
            FloatTitle = { link = '@markup.heading' },
            TabLineSel = { fg = colors.subtext1, bg = colors.surface0 },
            -- Telescope
            TelescopeBorder = { fg = colors.surface2 },
            TelescopeNormal = { fg = colors.overlay0 },
            TelescopeSelection = { fg = colors.text },
            TelescopeSelectionCaret = { fg = colors.green },
            TelescopeMatching = { fg = colors.teal, style = { 'bold' } },
            TelescopePromptTitle = { fg = colors.mauve },
            TelescopePromptNormal = { fg = colors.text },
            TelescopePromptPrefix = { fg = colors.blue },
            TelescopeResultsTitle = { fg = colors.text },
            TelescopePreviewTitle = { fg = colors.green },
            TelescopePreviewNormal = { fg = colors.text },
        }
    end,
    color_overrides = {
        mocha = {
            rosewater = '#efc9c2',
            flamingo = '#ebb2b2',
            pink = '#f2a7de',
            mauve = '#b889f4',
            red = '#ea7183',
            maroon = '#ea838c',
            peach = '#f39967',
            yellow = '#eaca89',
            green = '#96d382',
            teal = '#78cec1',
            sky = '#91d7e3',
            sapphire = '#68bae0',
            blue = '#739df2',
            lavender = '#a0a8f6',
            text = '#b5c1f1',
            subtext1 = '#a6b0d8',
            subtext0 = '#959ec2',
            overlay2 = '#848cad',
            overlay1 = '#717997',
            overlay0 = '#63677f',
            surface2 = '#505469',
            surface1 = '#3e4255',
            surface0 = '#2c2f40',
        },
    },
    integrations = {
        mason = true,
        cmp = true,
        treesitter = true,
        native_lsp = {
            enabled = true,
            underlines = {
                errors = { 'undercurl' },
                hints = { 'undercurl' },
                warnings = { 'undercurl' },
                information = { 'undercurl' },
            },
        },
    },
}

return PLUGIN
