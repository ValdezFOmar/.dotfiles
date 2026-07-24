---@type LazyPluginSpec
return {
    'saghen/blink.cmp',
    version = '1.*', -- needed for downloading pre-built binaries
    event = { 'InsertEnter', 'CmdlineEnter' },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'super-tab',
            ['<C-y>'] = { 'select_and_accept', 'fallback' },
            ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
            ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
            ['<M-k>'] = { 'select_prev', 'fallback_to_mappings' },
            ['<M-j>'] = { 'select_next', 'fallback_to_mappings' },
            ['<M-Tab>'] = { 'snippet_forward', 'fallback' },
        },
        snippets = { preset = 'luasnip' },
        completion = {
            menu = {
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
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
            },
        },
        --- experimental
        signature = {
            enabled = false,
        },
    },
}
