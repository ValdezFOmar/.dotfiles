local LSPCONFIG = { 'neovim/nvim-lspconfig', lazy = false } -- Required
local LSPZERO = { 'VonHeikemen/lsp-zero.nvim' }

-- Eventually change all of this to a manual configuration and ditch lsp-zero

LSPZERO.branch = 'v3.x'
LSPZERO.dependencies = {
    {
        -- Optional, for installing language servers
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
    },
    -- For Neovim Lua API
    { 'folke/neodev.nvim' },

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' }, -- Required
    { 'hrsh7th/cmp-nvim-lsp' }, -- Required
    { 'Issafalcon/lsp-overloads.nvim' }, -- For better overloads display
    {
        'L3MON4D3/LuaSnip', -- Required
        dependencies = {
            'rafamadriz/friendly-snippets',
            'saadparwaiz1/cmp_luasnip',
        },
    },
}

function LSPZERO.config()
    require('neodev').setup {} -- Neodev should be loaded before `lspconfig`
    local lsp_zero = require 'lsp-zero'

    lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings to learn the available actions
        lsp_zero.default_keymaps { buffer = bufnr }
        local keymap = vim.keymap.set

        -- lsp-overloads seem to work best with C# and is the only reason I've installed it
        if client.server_capabilities.signatureHelpProvider and vim.bo[bufnr].filetype == 'cs' then
            ---@diagnostic disable: missing-fields

            -- Should move this out
            require('lsp-overloads').setup(client, {
                ui = { border = 'rounded' },
                keymaps = { close_signature = '<M-o>' },
                display_automatically = false,
            })
            keymap(
                { 'i', 'n' },
                '<M-o>',
                '<cmd>LspOverloadsSignature<CR>',
                { noremap = true, silent = true, buffer = bufnr }
            )
        end

        local has_telescope, builtin = pcall(require, 'telescope.builtin')

        if has_telescope then
            keymap('n', '<leader>gd', builtin.lsp_definitions, { buffer = bufnr })
            keymap('n', '<leader>go', builtin.lsp_type_definitions, { buffer = bufnr })
            keymap('n', '<leader>gr', builtin.lsp_references, { buffer = bufnr })
        else
            vim.notify_once("Telescope couldn't be loaded, using default keymaps.", vim.log.levels.WARN)
        end
    end)

    -- LSP --
    require('mason').setup {
        ui = {
            border = 'rounded',
            icons = {
                package_installed = '✔ ',
                package_pending = '',
                package_uninstalled = '✗',
            },
        },
    }

    --[[ Consider a check for aarch64, becuase lua_ls doesn't support it
  function is_supported_platform()
      if vim.loop.os_uname().machine == 'aarch64' then
          return true
      end
      return false
  end
  --]]
    require('mason-lspconfig').setup {
        -- More language servers:
        -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
        ensure_installed = {
            'bashls',
            'cssls',
            'emmet_ls',
            'html',
            'jsonls',
            'tsserver',
            -- When there's an update to lua_ls, mason might brake with a message saying that
            -- the entries here are not valid. To solve this, comment out all this options in
            -- ensure installed, restart neovim, update with `MasonUpdate` then you can
            -- uncomment this and restart neovim.
            'lua_ls',
            'marksman',
            'basedpyright',
        },
        handlers = {
            lsp_zero.default_setup,
            lua_ls = function()
                -- Settings specific to Neovim for the lua language server, lua_ls
                local lua_opts = lsp_zero.nvim_lua_ls()
                require('lspconfig').lua_ls.setup(lua_opts)
            end,
            html = function()
                require('lspconfig').html.setup { filetypes = { 'html', 'templ', 'htmldjango' } }
            end,
        },
    }

    -- Add a border for transparent colorschemes
    require('lspconfig.ui.windows').default_options.border = 'rounded'

    -- Snippets --
    require('luasnip.loaders.from_vscode').lazy_load()
    local luasnip = require 'luasnip'
    luasnip.filetype_extend('htmldjango', { 'html' })

    -- Autocomplete --
    local cmp = require 'cmp'
    local cmp_action = lsp_zero.cmp_action()
    local cmp_format = lsp_zero.cmp_format {}

    -- If you want to insert `(` after select function or method item
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { filetypes = { sh = false } })

    cmp.setup {
        formatting = cmp_format,
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        }, {
            { name = 'buffer' },
        }),
        mapping = cmp.mapping.preset.insert {
            -- This little snippet will:
            -- 1. Confirm with tab, and if no entry is selected, will confirm the first item
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    local entry = cmp.get_selected_entry()
                    if not entry then
                        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                    end
                    cmp.confirm()
                else
                    fallback()
                end
            end, { 'i', 's' }),

            -- Navigate sugestions up
            ['<C-k>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
                else
                    fallback()
                end
            end, { 'i', 's' }),

            -- Navigate sugestions down
            ['<C-j>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                else
                    fallback()
                end
            end, { 'i', 's' }),

            -- Ctrl+Space to trigger completion menu
            ['<C-Space>'] = cmp.mapping.complete(),

            -- Navigate between snippet placeholder
            ['<A-Tab>'] = cmp_action.luasnip_jump_forward(),
            ['<A-f>'] = cmp_action.luasnip_jump_forward(),
            ['<A-b>'] = cmp_action.luasnip_jump_backward(),
        },
    }
end

return { LSPCONFIG, LSPZERO }
