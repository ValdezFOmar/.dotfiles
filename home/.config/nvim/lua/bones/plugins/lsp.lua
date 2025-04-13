---@type LazyPluginSpec
local PLUGIN = { 'neovim/nvim-lspconfig' }

PLUGIN.lazy = false

function PLUGIN.config()
    local lspconfig = require 'lspconfig'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.config('*', { capabilities = capabilities })
    lspconfig.eslint.setup { capabilities = capabilities }
end

return PLUGIN
