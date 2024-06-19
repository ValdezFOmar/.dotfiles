local PLUGIN = { 'folke/lazydev.nvim' }

PLUGIN.ft = 'lua'
PLUGIN.dependencies = { { 'Bilal2453/luvit-meta', lazy = true } }
PLUGIN.opts = {
    library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    },
}

return PLUGIN
