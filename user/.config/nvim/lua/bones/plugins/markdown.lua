local PLUGIN = { 'MeanderingProgrammer/markdown.nvim' }

PLUGIN.dependencies = { 'nvim-treesitter/nvim-treesitter' }
PLUGIN.ft = { 'markdown' }
PLUGIN.main = 'render-markdown'

---@type render.md.UserConfig
PLUGIN.opts = {
    anti_conceal = { enabled = false },
    win_options = {
        conceallevel = { rendered = 2 },
        concealcursor = { rendered = 'nc' },
    },
    code = {
        highlight = 'CursorColumn',
        border = 'thick',
        width = 'block',
        style = 'normal',
        left_pad = 1,
        right_pad = 1,
    },
    overrides = {
        buftype = {
            nofile = {
                -- Padding breaks code blocks in hover windows
                code = {
                    left_pad = 0,
                    right_pad = 0,
                    width = 'full',
                },
            },
        },
    },
}

return PLUGIN
