local PLUGIN = { 'catppuccin/nvim' }

PLUGIN.name = 'catppuccin'
PLUGIN.lazy = false
PLUGIN.priority = 1000

function PLUGIN.config()
    require('catppuccin').setup {
        flavor = 'mocha',
        background = { dark = 'mocha' },
        transparent_background = true,
        styles = {
            conditionals = { 'italic' },
            loops = { 'italic' },
            keywords = { 'italic' },
            -- booleans = { "italic" },
        },
        custom_highlights = function(colors)
            local builtin = '#7d7ddb' -- Original builtin #8888C6
            local documentation = '#71a162'
            return {
                -- General config
                ['@lsp.type.comment'] = {}, -- Disabled becuase it overrides usefull highlighting
                ['@constant.builtin'] = { fg = colors.pink, style = {} },
                ['@variable.builtin'] = { style = { 'italic' } },
                ['@keyword.operator'] = { link = 'Keyword' },
                ['@keyword.conditional.ternary'] = { link = 'Operator' },
                ['@attribute'] = { fg = colors.green },
                ['@attribute.builtin'] = { link = '@attribute' },
                ['@lsp.type.decorator'] = { link = '@attribute' },
                ['@attribute.diff'] = { fg = colors.sapphire },
                ['@function.builtin'] = { fg = builtin },
                ['@function.builtin.bash'] = { link = '@function.builtin' },
                ['@markup.quote.markdown'] = { fg = colors.mauve },
                ['@markup.link.url'] = { fg = colors.sapphire, style = { 'underline' } },
                ['@markup.link.vimdoc'] = { fg = colors.mauve, style = { 'underline' } },
                ['@string.special.url'] = { fg = colors.sapphire, style = { 'underline' } },
                -- SQL
                ['@keyword.sql'] = { fg = colors.mauve },
                ['@keyword.operator.sql'] = { fg = colors.mauve },
                -- Python
                DevIconPy = { fg = colors.blue },
                ['@string.documentation.python'] = { fg = documentation },
                ['@punctuation.bracket.htmldjango'] = { fg = colors.teal },
                -- HTML
                ['@tag.attribute'] = { link = '@property' },
                ['@tag.delimiter'] = { fg = colors.overlay2 },
                -- GUI
                FloatBorder = { fg = colors.surface2 },
                TabLineSel = { fg = colors.subtext1, bg = colors.surface0 },
                -- Telescope
                TelescopeBorder = { fg = colors.surface2 },
                TelescopeNormal = { fg = colors.overlay0 },
                TelescopeSelection = { fg = colors.text },
                TelescopeSelectionCaret = { fg = colors.peach },
                TelescopeMatching = { fg = colors.peach, style = { 'bold' } },
                TelescopePromptTitle = { fg = colors.peach },
                TelescopePromptNormal = { fg = colors.text },
                TelescopePromptPrefix = { fg = colors.peach },
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
                base = '#09090B',
                mantle = '#161618',
                crust = '#161618',
            },
        },
        integrations = {
            mason = true,
            cmp = true,
            gitsigns = true,
            nvimtree = true,
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
    vim.cmd.colorscheme 'catppuccin'
end

return PLUGIN
