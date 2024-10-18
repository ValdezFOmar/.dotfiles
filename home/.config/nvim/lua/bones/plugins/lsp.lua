local PLUGIN = { 'williamboman/mason.nvim' }

PLUGIN.lazy = false
PLUGIN.dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
}

local servers = {
    'basedpyright',
    'bashls', -- needs 'shellcheck' and 'shfmt'
    'cssls',
    'emmet_ls',
    'html',
    'jsonls',
    'marksman',
    'ts_ls',
}

-- Skip this servers in TERMUX since the platform is unsupported
if vim.uv.os_uname().machine ~= 'aarch64' then
    table.insert(servers, 'lua_ls')
    table.insert(servers, 'rust_analyzer')
end

---@param config table?
---@return function
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
end

return PLUGIN
