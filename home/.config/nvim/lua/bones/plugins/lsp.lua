---@type LazyPluginSpec
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

---Setup a server with cmp default capabilities
---@param config_name string
---@param config table?
local function setup(config_name, config)
    config = config or {}
    config.capabilities = require('cmp_nvim_lsp').default_capabilities()
    require('lspconfig')[config_name].setup(config)
end

---@param config table?
---@return fun(config_name: string)
local function handler(config)
    return function(config_name)
        setup(config_name, config)
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
            -- default handler
            handler(),
            html = handler { filetypes = { 'html', 'templ', 'htmldjango' } },
            basedpyright = handler {
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

    if vim.fn.executable 'ts_query_ls' == 1 then
        local data_path = vim.fn.stdpath 'data' --[[@as string]]

        setup('ts_query_ls', {
            settings = {
                parser_install_directories = {
                    vim.fs.joinpath(vim.fn.getcwd(), 'parser'),
                    vim.fs.joinpath(data_path, 'lazy', 'nvim-treesitter', 'parser'),
                },
            },
        })
    end
end

return PLUGIN
