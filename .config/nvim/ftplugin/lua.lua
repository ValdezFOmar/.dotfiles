local set = vim.opt

set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.expandtab = true

vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.lua",
    callback = function () vim.lsp.buf.format() end,
        group = vim.api.nvim_create_augroup("lua_formatter", { clear = true }),
        desc = "Run formatter for lua",
    }
)
