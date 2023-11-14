local built_in_function = "#8888C6"

return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavor = "mocha",
      background = {
        dark = "mocha",
      },
      -- transparent_background = true,
      styles = {
        conditionals = { "italic" },
        loops = { "italic" },
        keywords = { "italic" },
        booleans = { "italic" }
      },
      integrations = {
        mason = true,
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = false,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
      color_overrides = {
        mocha = {
          rosewater = "#efc9c2",
          flamingo = "#ebb2b2",
          pink = "#f2a7de",
          mauve = "#b889f4",
          red = "#ea7183",
          maroon = "#ea838c",
          peach = "#f39967",
          yellow = "#eaca89",
          green = "#96d382",
          teal = "#78cec1",
          sky = "#91d7e3",
          sapphire = "#68bae0",
          blue = "#739df2",
          lavender = "#a0a8f6",
          text = "#b5c1f1",
          subtext1 = "#a6b0d8",
          subtext0 = "#959ec2",
          overlay2 = "#848cad",
          overlay1 = "#717997",
          overlay0 = "#63677f",
          surface2 = "#505469",
          surface1 = "#3e4255",
          surface0 = "#2c2f40",
          base = "#09090B",
          mantle = "#161618",
          crust = "#161618",
        }
      },
      highlight_overrides = {
        all = function(colors)
          local mocha = require("catppuccin.palettes").get_palette "mocha"

          return {
            Boolean = { fg = mocha.pink },
            Number = { fg = mocha.mauve },
            ["@constant.builtin"] = { fg = mocha.pink },
            ["@function.builtin"] = { fg = built_in_function },
          }
        end
      }
    })
    vim.cmd.colorscheme "catppuccin"
  end,
}
