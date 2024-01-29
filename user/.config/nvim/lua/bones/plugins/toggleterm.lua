local PLUGIN = { "akinsho/toggleterm.nvim" }

PLUGIN.version = "*"

PLUGIN.opts = {
  open_mapping = "<C-s>",
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = -40,
  direction = "float",
  auto_scroll = true,
  float_opts = {
    border = "curved",
    -- winblend = 15,
  },
}

return PLUGIN
