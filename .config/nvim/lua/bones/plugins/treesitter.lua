return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "luadoc",
        "python",
        "toml",
        "javascript",
        "typescript",
        "html",
        "htmldjango",
        "css",
        "json",
        "jsdoc",
        "vue",
        "markdown",
        "markdown_inline",
        "bash",
        "csv",
        "git_config",
        "gitignore",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,
      indent = { enable = true },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  end
}
