local PLUGIN = { "NvChad/nvim-colorizer.lua" }

PLUGIN.opts = {}

PLUGIN.opts.filetypes = {
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
    css = true, -- Enable all CSS features
    mode = "virtualtext",
    virtualtext = "❮color❯",
  },
}

PLUGIN.opts.user_default_options = {
  RGB = true, -- #RGB hex codes
  RRGGBB = true, -- #RRGGBB hex codes
  names = false, -- "Name" codes like Blue or blue
  RRGGBBAA = true, -- #RRGGBBAA hex codes
  AARRGGBB = false, -- 0xAARRGGBB hex codes

  -- Available modes for `mode`: foreground, background,  virtualtext
  mode = "foreground",
  virtualtext = "■",

  -- Available methods are false / true / "normal" / "lsp" / "both"
  -- True is same as normal
  tailwind = true,
  -- parsers can contain values used in |user_default_options|
  sass = { enable = false, parsers = { "css" } },
  always_update = false,
}

return PLUGIN
