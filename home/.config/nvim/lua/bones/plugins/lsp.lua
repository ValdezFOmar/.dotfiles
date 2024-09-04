local PLUGIN = { 'williamboman/mason.nvim' }

PLUGIN.lazy = false
PLUGIN.dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
}

local servers = {
    'basedpyright',
    'bashls',
    'cssls',
    'emmet_ls',
    'html',
    'jsonls',
    'marksman',
    'rust_analyzer',
    'taplo',
    'tsserver',
}

-- lua_ls doesn't support aarch64
if vim.uv.os_uname().machine ~= 'aarch64' then
    table.insert(servers, 'lua_ls')
end

local function server_config(config)
    config = config or {}
    return function(server)
        config.capabilities = require('cmp_nvim_lsp').default_capabilities()
        require('lspconfig')[server].setup(config)
    end
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

    require('mason-lspconfig').setup {
        ensure_installed = servers,
        handlers = {
            -- default setup
            server_config(),
            html = server_config { filetypes = { 'html', 'templ', 'htmldjango' } },
            basedpyright = server_config {
                settings = {
                    basedpyright = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = 'openFilesOnly',
                            typeCheckingMode = 'standard',
                        },
                    },
                },
            },
        },
    }

    -- Add a border for transparent colorschemes
    require('lspconfig.ui.windows').default_options.border = 'rounded'
end

return PLUGIN
