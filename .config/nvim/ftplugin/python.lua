local set = vim.opt

set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true

-- group options prevents multiple executions. See https://neovim.discourse.group/t/vimscript-autocmd-to-lua/2932
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.py",
        command = "silent! !black %; isort %",
        group = vim.api.nvim_create_augroup("python_formatter", { clear = true }),
        desc = "Run formatter for python",
    }
)
