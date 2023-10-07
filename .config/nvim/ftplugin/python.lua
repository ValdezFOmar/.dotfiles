local set = vim.opt

set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true

vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.py",
        command = "silent! !black %; isort %",
        desc = "Run formatter for python"
    }
)
