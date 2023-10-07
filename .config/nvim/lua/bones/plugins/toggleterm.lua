return {
    'akinsho/toggleterm.nvim',
    version = "v2.8*",
    config = function()
        require("toggleterm").setup {
            open_mapping = "<C-s>",
            hide_numbers = true,
            shade_terminals = true,
            shading_factor = -40,
            direction = "float",
            auto_scroll = true,
            float_opts = {
                border = "curved"
            }
        }
    end,
}
