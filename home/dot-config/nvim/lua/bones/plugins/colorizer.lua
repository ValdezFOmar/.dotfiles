---@type LazyPluginSpec
return {
    'NvChad/nvim-colorizer.lua',
    opts = {
        filetypes = {
            '*',
            '!lazy',
            '!mason',
            '!man',
            '!markdown',
            '!gitcommit',
            '!diff',
            css = {
                rgb_fn = true,
                hsl_fn = true,
                names = true,
            },
            rasi = {
                css = true, -- Enable all CSS features
            },
        },
        user_default_options = {
            mode = 'virtualtext',
            virtualtext = ' ',
            RGB = true,
            RRGGBB = true,
            names = false, -- "Name" codes like Blue or blue
            RRGGBBAA = true,
            AARRGGBB = false,
            tailwind = true,
            sass = { enable = false, parsers = { 'css' } },
            always_update = false,
        },
    },
}
