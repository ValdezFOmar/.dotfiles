local PLUGIN = { 'williamboman/mason.nvim' }

PLUGIN.lazy = false
PLUGIN.dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
}

local servers = {
    'bashls',
    'cssls',
    'emmet_ls',
    'html',
    'jsonls',
    'tsserver',
    'marksman',
    'basedpyright',
}

-- lua_ls doesn't support aarch64
if vim.uv.os_uname().machine ~= 'aarch64' then
    table.insert(servers, 'lua_ls')
end

function PLUGIN.config()
    require('mason').setup {
        ui = {
            border = 'rounded',
            icons = {
                package_installed = '✔',
                package_pending = '',
                package_uninstalled = '✗',
            },
        },
    }

    local lspconfig = require 'lspconfig'
    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    require('mason-lspconfig').setup {
        ensure_installed = servers,
        handlers = {
            -- default setup
            function(server)
                lspconfig[server].setup { capabilities = lsp_capabilities }
            end,
            html = function()
                lspconfig.html.setup {
                    capabilities = lsp_capabilities,
                    filetypes = { 'html', 'templ', 'htmldjango' },
                }
            end,
        },
    }

    -- Add a border for transparent colorschemes
    require('lspconfig.ui.windows').default_options.border = 'rounded'
end

return PLUGIN
