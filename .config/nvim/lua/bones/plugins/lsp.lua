return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' },                 -- Required
    { 'williamboman/mason.nvim' },               -- Optional
    { 'williamboman/mason-lspconfig.nvim' },     -- Optional

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },         -- Required
    { 'hrsh7th/cmp-nvim-lsp' },     -- Required
    { 'L3MON4D3/LuaSnip' },         -- Required
  },
  config = function()
    local lsp = require('lsp-zero').preset({})

    lsp.on_attach(function(client, bufnr)
      -- see :help lsp-zero-keybindings
      -- to learn the available actions
      lsp.default_keymaps({ buffer = bufnr })
    end)

    -- More language servers:
    -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
    lsp.ensure_installed({
      "bashls",
      "cssls",
      "emmet_ls",
      "html",
      "jsonls",
      "tsserver",
      "lua_ls",
      "marksman",
      "volar",
      "pyright"
    })

    -- Settings specific to Neovim for the lua language server, lua_ls
    require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

    lsp.setup()

    local cmp = require("cmp")
    local cmp_action = require("lsp-zero").cmp_action()
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')

    -- If you want insert `(` after select function or method item
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )

    cmp.setup({
      window = {
        completition = cmp.config.window.bordered(),
      },
      mapping = {
        -- This little snippet will confirm with tab, and
        -- if no entry is selected, will confirm the first item
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            if not entry then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              cmp.confirm()
            else
              cmp.confirm()
            end
          else
            fallback()
          end
        end, { "i", "s" }),

        -- If something has explicitly been selected by the user, select it.
        -- Else, just enter a new line.
        ["<CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
          c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),

        -- Navigate sugestions up
        ["<C-k>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Navigate sugestions down
        ["<C-j>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Navigate between snippet placeholder
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
      }
    })
  end,
}
