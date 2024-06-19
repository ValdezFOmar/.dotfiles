local PLUGIN = { 'MeanderingProgrammer/markdown.nvim' }

PLUGIN.dependencies = { 'nvim-treesitter/nvim-treesitter' }
PLUGIN.ft = { 'markdown' }

---@class RGBColor
---@field public r integer
---@field public g integer
---@field public b integer

---@class HSVColor
---@field public h integer
---@field public s integer
---@field public v integer

---Clamp a value between a range
---@param lower integer
---@param value integer
---@param upper integer
---@return integer
local function clamp(lower, value, upper)
    return math.max(lower, math.min(value, upper))
end

---Split a number representing an RGB value into its individual red,
---green and blue components
---@param number integer
---@return RGBColor
local function int_to_RGB(number)
    ---@type RGBColor
    return {
        r = bit.band(bit.rshift(number, 16), 0xFF),
        g = bit.band(bit.rshift(number, 8), 0xFF),
        b = bit.band(number, 0xFF), -- tecnically: bit.band(bit.rshift(number, 0), 0xFF),
    }
end

---Convert and RGB color to a integer
---@param color RGBColor
---@return integer
local function RGB_to_int(color)
    return bit.lshift(color.r, 16) + bit.lshift(color.g, 8) + color.b
end

---Convert from RGB to HSV
---[Reference](https://en.wikipedia.org/wiki/HSL_and_HSV#From_RGB)
---@param color RGBColor
---@return HSVColor
local function RGB_to_HSV(color)
    local R, G, B = color.r / 255, color.g / 255, color.b / 255
    local cmax = math.max(R, G, B) -- Value
    local cmin = math.min(R, G, B)
    local C = cmax - cmin -- chroma
    local hue = (function()
        if C == 0 then
            return 0
        elseif cmax == R then
            return 60 * (((G - B) / C) % 6)
        elseif cmax == G then
            return 60 * (((B - R) / C) + 2)
        elseif cmax == B then
            return 60 * (((R - G) / C) + 4)
        end
    end)()
    local saturation = cmax == 0 and 0 or C / cmax
    ---@type HSVColor
    return { h = hue, s = saturation, v = cmax }
end

---Convert HSV to RGB color
---[Reference](https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_RGB)
---@param color HSVColor
---@return RGBColor
local function HSV_to_RGB(color)
    local C = color.v * color.s
    local Hp = color.h / 60
    local X = C * (1 - math.abs(Hp % 2 - 1))
    local R1, G1, B1 = (function()
        if 0 <= Hp and Hp < 1 then
            return C, X, 0
        elseif 1 <= Hp and Hp < 2 then
            return X, C, 0
        elseif 2 <= Hp and Hp < 3 then
            return 0, C, X
        elseif 3 <= Hp and Hp < 4 then
            return 0, X, C
        elseif 4 <= Hp and Hp < 5 then
            return X, 0, C
        elseif 5 <= Hp and Hp < 6 then
            return C, 0, X
        end
    end)()
    local m = color.v - C
    ---@type RGBColor
    return {
        r = clamp(0, vim.fn.round((R1 + m) * 255), 255),
        g = clamp(0, vim.fn.round((G1 + m) * 255), 255),
        b = clamp(0, vim.fn.round((B1 + m) * 255), 255),
    }
end

---Set the `value` attribute of a HSV color to a percentaje of its current value
---@param color HSVColor
---@param percent number
---@return HSVColor
local function set_value_percentage(color, percent)
    color.v = color.v * clamp(0, percent, 1)
    return color
end

local MARKDOWN_HEADINGS = 6

---Generate background highlights for headings based on the colors for
---`@markup.heading.n.markdown`, where `n` is the number of a markdown heading.
---@param value number
---@return string[] highlight_groups The list of highlight groups created
local function generate_highlights(value)
    local highlight_groups = {}
    for N = 1, MARKDOWN_HEADINGS do
        local highlight = vim.api.nvim_get_hl(0, { name = 'markdownH' .. N })
        while not highlight.fg do
            if not highlight.link then
                highlight = vim.api.nvim_get_hl(0, { name = 'Normal' }) -- just in case
                break
            end
            highlight = vim.api.nvim_get_hl(0, { name = highlight.link })
        end
        local rgb_color = HSV_to_RGB(set_value_percentage(RGB_to_HSV(int_to_RGB(highlight.fg)), value))
        local highlight_name = 'RenderMarkdownHeadingBG' .. N
        vim.api.nvim_set_hl(0, highlight_name, { bg = RGB_to_int(rgb_color) })
        table.insert(highlight_groups, highlight_name)
    end
    return highlight_groups
end

function PLUGIN.config()
    local value = 0.30

    require('render-markdown').setup {
        highlights = {
            heading = {
                backgrounds = generate_highlights(value),
            },
            code = 'CursorColumn',
        },
        win_options = { conceallevel = { rendered = 2 } },
    }

    vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('MarkdownHeadings', { clear = true }),
        desc = 'Re-generate custom group highlights when switching color scheme',
        callback = function()
            generate_highlights(value)
        end,
    })
end

return PLUGIN
