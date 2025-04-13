local border = 'rounded'

---@type LazyPluginSpec
return {
    'saghen/blink.cmp',
    version = '1.*',

    lazy = true,

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            ['<C-p>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-n>'] = { 'scroll_documentation_down', 'fallback' },
            ['<M-k>'] = { 'select_prev', 'fallback_to_mappings' },
            ['<M-j>'] = { 'select_next', 'fallback_to_mappings' },
            ['<M-Tab>'] = { 'select_and_accept' },
        },
        snippets = { preset = 'luasnip' },
        completion = {
            menu = {
                border = border,
                draw = {
                    columns = { { 'kind_icon' }, { 'label', 'source_name', gap = 1 } },
                    components = {
                        label = {
                            ellipsis = true,
                            width = { fill = true, max = 60 },
                        },
                    },
                },
            },
            ghost_text = { enabled = true },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
                window = { border = border },
            },
        },
        --- experimental
        signature = {
            enabled = true,
            window = { border = border },
        },
    },
}
