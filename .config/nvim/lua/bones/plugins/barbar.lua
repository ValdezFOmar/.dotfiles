local PLUGIN = { 'romgrk/barbar.nvim' }

PLUGIN.version = '^1.0.0'

PLUGIN.dependencies = {
  'nvim-tree/nvim-web-devicons',
}

PLUGIN.init = function()
  vim.g.barbar_auto_setup = false
end

PLUGIN.opts = {
  auto_hide = 1,
  tabpages = false,
}

return PLUGIN
