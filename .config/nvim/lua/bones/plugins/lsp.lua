local PLUGIN = { "VonHeikemen/lsp-zero.nvim" }

PLUGIN.branch = "v3.x"
PLUGIN.dependencies = {
  -- LSP Support
  { "neovim/nvim-lspconfig" }, -- Required
  { "williamboman/mason.nvim" }, -- Optional
  { "williamboman/mason-lspconfig.nvim" }, -- Optional
  { "folke/neodev.nvim" }, -- Optional (For Neovim Lua API)

  -- Autocompletion
  { "hrsh7th/nvim-cmp" }, -- Required
  { "hrsh7th/cmp-nvim-lsp" }, -- Required
  {
    "L3MON4D3/LuaSnip", -- Required
    dependencies = {
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
  },
}

function PLUGIN.config()
  require("neodev").setup {} -- Neodev should be loaded before `lspconfig`
  local lsp_zero = require("lsp-zero").preset {}

  lsp_zero.on_attach(function(_, bufnr)
    -- see :help lsp-zero-keybindings to learn the available actions
    lsp_zero.default_keymaps { buffer = bufnr }

    local has_telescope, builtin = pcall(require, "telescope.builtin")

    if not has_telescope then
      vim.notify_once("Telescope couldn't be loaded, using default keymaps.", vim.log.levels.WARN)
      return
    end

    local keymap = vim.keymap.set
    keymap("n", "<leader>gd", builtin.lsp_definitions, { buffer = bufnr })
    keymap("n", "<leader>go", builtin.lsp_type_definitions, { buffer = bufnr })
    keymap("n", "<leader>gr", builtin.lsp_references, { buffer = bufnr })
  end)

  -- LSP --
  require("mason").setup {
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✔ ",
        package_pending = "",
        package_uninstalled = "✗",
      },
    },
  }
  require("mason-lspconfig").setup {
    -- More language servers:
    -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
    ensure_installed = {
      "bashls",
      "cssls",
      "emmet_ls",
      "html",
      "jsonls",
      "tsserver",
      "lua_ls",
      "marksman",
      "volar",
      "pyright",
    },
    handlers = {
      lsp_zero.default_setup,
      lua_ls = function()
        -- Settings specific to Neovim for the lua language server, lua_ls
        local lua_opts = lsp_zero.nvim_lua_ls()
        require("lspconfig").lua_ls.setup(lua_opts)
      end,
    },
  }
  -- Add a border for transparent colorschemes
  -- NOTE: This is an unstable API
  require("lspconfig.ui.windows").default_options.border = "rounded"

  -- Snippets --
  require("luasnip.loaders.from_vscode").lazy_load()
  local luasnip = require "luasnip"
  luasnip.filetype_extend("python", { "django" })
  -- add frameworks' snippets: https://github.com/rafamadriz/friendly-snippets#add-snippets-from-a-framework-to-a-filetype

  -- Autocomplete --
  local cmp = require "cmp"
  local cmp_action = lsp_zero.cmp_action()
  local cmp_format = lsp_zero.cmp_format()

  -- If you want to insert `(` after select function or method item
  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { filetypes = { sh = false } })

  cmp.setup {
    formatting = cmp_format,
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
    }),
    mapping = cmp.mapping.preset.insert {
      -- This little snippet will:
      -- 1. Confirm with tab, and if no entry is selected, will confirm the first item
      -- 2. Will jump between the editable parts of a snippet
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          local entry = cmp.get_selected_entry()
          if not entry then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          end
          cmp.confirm()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),

      -- This will force jump or expand
      ["<A-Tab>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end),

      -- If nothing is selected (including preselections) add a newline as usual.
      -- If something has explicitly been selected by the user, select it.
      ["<CR>"] = cmp.mapping {
        i = function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
          else
            fallback()
          end
        end,
        s = cmp.mapping.confirm { select = true },
        c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
      },

      -- Navigate sugestions up
      ["<C-k>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
        else
          fallback()
        end
      end, { "i", "s" }),

      -- Navigate sugestions down
      ["<C-j>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        else
          fallback()
        end
      end, { "i", "s" }),

      -- Ctrl+Space to trigger completion menu
      ["<C-Space>"] = cmp.mapping.complete(),

      -- Navigate between snippet placeholder
      ["<C-f>"] = cmp_action.luasnip_jump_forward(),
      ["<C-b>"] = cmp_action.luasnip_jump_backward(),
    },
  }
end

return PLUGIN
