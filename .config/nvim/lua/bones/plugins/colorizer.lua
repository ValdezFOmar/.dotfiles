return {
  'NvChad/nvim-colorizer.lua',
  opts = {
    filetypes = {
      "*",
      "!lazy",
      "!mason",
      css = {
        rgb_fn = true,
        hsl_fn = true,
        names = true,
        mode = "virtualtext",
        virtualtext = "❮color❯",
      },
      rasi = {
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        mode = "virtualtext",
        virtualtext = "❮color❯",
      }
    },
    user_default_options = {
      RGB = true,       -- #RGB hex codes
      RRGGBB = true,    -- #RRGGBB hex codes
      names = false,    -- "Name" codes like Blue or blue
      RRGGBBAA = true,  -- #RRGGBBAA hex codes
      AARRGGBB = false, -- 0xAARRGGBB hex codes

      -- Available modes for `mode`: foreground, background,  virtualtext
      mode = "foreground",
      virtualtext = "■",

      -- Available methods are false / true / "normal" / "lsp" / "both"
      -- True is same as normal
      tailwind = true, -- Enable tailwind colors

      -- parsers can contain values used in |user_default_options|
      sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors

      -- update color values even if buffer is not focused
      -- example use: cmp_menu, cmp_docs
      always_update = false
    },
    -- all the sub-options of filetypes apply to buftypes
    buftypes = {},
  }
}
