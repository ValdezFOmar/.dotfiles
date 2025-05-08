local PLUGIN = { 'L3MON4D3/LuaSnip' }

PLUGIN.dependencies = { 'rafamadriz/friendly-snippets' }

function PLUGIN.config()
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

    luasnip.add_snippets('javascript', {
        s('annotation', { t '/** @', i(1, 'type'), t ' {', i(2), t '} **/' }),
    })

    for _, ft in ipairs { 'javascript', 'typescript', 'c', 'cpp' } do
        luasnip.add_snippets(ft, {
            s('doccomment', { t { '/**', ' * ' }, i(1), t { '', ' */' } }),
            s('comment', { t '/* ', i(1), t ' */' }),
        })
    end
end

return PLUGIN
