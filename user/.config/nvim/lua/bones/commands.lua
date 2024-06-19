vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('LspKeyMaps', {}),
    desc = 'Lsp Key Mappings',
    callback = function(event)
        local opts = { buffer = event.buf }
        local remap = vim.keymap.set

        remap('n', '<F2>', vim.lsp.buf.rename, opts)
        remap({ 'n', 'v' }, '<F3>', vim.lsp.buf.format, opts)
        remap('n', '<F4>', vim.lsp.buf.code_action, opts)

        -- Use Telescope if available, else use neovim native implementations
        local ok, builtin = pcall(require, 'telescope.builtin')
        local goto_definition = ok and builtin.lsp_definitions or vim.lsp.buf.definition
        local goto_type_def = ok and builtin.lsp_type_definitions or vim.lsp.buf.type_definition
        local show_references = ok and builtin.lsp_references or vim.lsp.buf.references

        remap('n', 'gd', goto_definition, opts)
        remap('n', 'gt', goto_type_def, opts)
        remap('n', '<leader>lr', show_references, opts)
    end,
})

vim.api.nvim_create_user_command('ToggleDiagnostics', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle diagnostics' })
