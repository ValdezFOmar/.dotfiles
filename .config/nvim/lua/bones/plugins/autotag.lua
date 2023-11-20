-- docs for usage
-- :h nvim-surround.usage

local ft = {
  'html',
  'htmldjango',
  'javascript',
  'javascriptreact',
  'jsx',
  'markdown',
  'tsx',
  'typescript',
  'typescriptreact',
  'vue',
  'xml',
}

return {
  "windwp/nvim-ts-autotag",
  opts = {
    filetypes = ft
  },
  ft = ft
}
