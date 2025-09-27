---@type LazyPluginSpec
local PLUGIN = { 'MeanderingProgrammer/render-markdown.nvim' }

PLUGIN.dependencies = { 'nvim-treesitter/nvim-treesitter' }
PLUGIN.ft = { 'markdown' }

---@module 'render-markdown'
---@type render.md.UserConfig
PLUGIN.opts = {
    anti_conceal = { enabled = false },
    win_options = {
        conceallevel = { rendered = 2 },
        concealcursor = { rendered = 'nc' },
    },
    completions = {
        lsp = { enabled = true },
        filter = {
            callout = function(callout)
                return callout.category ~= 'obsidian'
            end,
        },
    },
    code = {
        left_pad = 1,
        right_pad = 1,
        style = 'full',
        width = 'block',
        border = 'thick',
        language_icon = false,
        language_name = false,
        highlight = 'CursorColumn',
    },
    overrides = {
        buftype = {
            nofile = {
                -- Padding breaks code blocks in hover windows
                code = {
                    left_pad = 0,
                    right_pad = 0,
                    width = 'full',
                    border = 'hide',
                    style = 'normal',
                },
            },
        },
    },
}

return PLUGIN
