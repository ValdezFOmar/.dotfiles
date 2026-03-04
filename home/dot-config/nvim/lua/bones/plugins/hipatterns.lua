local function hex_extmark_opts(_, _, data)
    return {
        virt_text = { { ' ██', data.hl_group } },
        virt_text_pos = 'inline',
        right_gravity = false,
    }
end

---@type LazyPluginSpec
return {
    'nvim-mini/mini.hipatterns',
    opts = {
        highlighters = {
            hexcolor3 = {
                pattern = function(buf)
                    return vim.bo[buf].ft == 'css' and '#%x%x%x()()%f[%W]' or nil
                end,
                group = function(_, _, data)
                    local m = data.full_match ---@type string
                    local r, g, b = m:sub(2, 2), m:sub(3, 3), m:sub(4, 4)
                    local color = '#' .. r .. r .. g .. g .. b .. b
                    return MiniHipatterns.compute_hex_color_group(color, 'bg')
                end,
                extmark_opts = hex_extmark_opts,
            },
            hexcolor6 = {
                pattern = '#%x%x%x%x%x%x()()%f[%W]',
                group = function(_, _, data)
                    return MiniHipatterns.compute_hex_color_group(data.full_match, 'fg')
                end,
                extmark_opts = hex_extmark_opts,
            },
            hexcolor8 = {
                pattern = '#%x%x%x%x%x%x%x%x()()%f[%W]',
                group = function(_, _, data)
                    return MiniHipatterns.compute_hex_color_group(data.full_match:sub(1, 7), 'fg')
                end,
                extmark_opts = hex_extmark_opts,
            },
        },
    },
}
