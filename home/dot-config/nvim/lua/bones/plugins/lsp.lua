---@type LazyPluginSpec
local PLUGIN = { 'neovim/nvim-lspconfig' }

PLUGIN.lazy = false

function PLUGIN.config()
    local lspconfig = require 'lspconfig'
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    lspconfig.eslint.setup { capabilities = capabilities }
end

return PLUGIN
