local PLUGIN = { "windwp/nvim-ts-autotag" }

local ft = {
  "html",
  "htmldjango",
  "javascript",
  "javascriptreact",
  "jsx",
  "markdown",
  "tsx",
  "typescript",
  "typescriptreact",
  "vue",
  "xml",
}

PLUGIN.ft = ft

PLUGIN.opts = {
  filetypes = ft,
}

return PLUGIN
