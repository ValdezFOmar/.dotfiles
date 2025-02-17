---@type LazyPluginSpec
local PLUGIN = { 'neovim/nvim-lspconfig' }

PLUGIN.lazy = false

function PLUGIN.config()
    local lspconfig = require 'lspconfig'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local data_path = vim.fn.stdpath 'data' --[[@as string]]

    ---@type table<string, table>
    local servers = {
        bashls = {}, -- needs 'shellcheck' and 'shfmt'
        cssls = {},
        emmet_language_server = {},
        eslint = {},
        html = {},
        jsonls = {},
        lua_ls = {},
        marksman = {},
        rust_analyzer = {},
        ts_ls = {},
        basedpyright = {
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
        ts_query_ls = {
            settings = {
                parser_install_directories = {
                    vim.fs.joinpath(vim.fn.getcwd(), 'parser'),
                    vim.fs.joinpath(data_path, 'lazy', 'nvim-treesitter', 'parser'),
                },
            },
        },
    }

    for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
    end
end

return PLUGIN
