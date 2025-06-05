---@type LazyPluginSpec
return {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
        local luasnip = require 'luasnip'

        -- Extensions
        luasnip.filetype_extend('htmldjango', { 'html' })
        for _, ft in ipairs { 'html', 'htmldjango', 'latex', 'markdown', 'tex', 'text' } do
            luasnip.filetype_extend(ft, { 'loremipsum' })
        end

        -- Snippets
        local s = luasnip.snippet
        local t = luasnip.text_node
        local i = luasnip.insert_node
        for _, ft in ipairs { 'javascript', 'typescript' } do
            luasnip.add_snippets(ft, {
                s('annotation', { t '/** @', i(1, 'type'), t ' {', i(2), t '} **/' }),
                s('doccomment', { t { '/**', ' * ' }, i(1), t { '', ' */' } }),
            })
        end
    end,
}
