local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local user_command = vim.api.nvim_create_user_command

autocmd('LspAttach', {
    group = augroup('LspKeyMaps', {}),
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

autocmd('TextYankPost', {
    group = augroup('HighlightYank', {}),
    pattern = '*',
    callback = function()
        vim.highlight.on_yank { timeout = 800 }
    end,
})

user_command('ToggleDiagnostics', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle diagnostics' })

user_command('ToggleWrap', function()
    ---@diagnostic disable:undefined-field
    vim.opt_local.wrap = not vim.opt_local.wrap:get()
    vim.opt_local.linebreak = not vim.opt_local.linebreak:get()
    vim.opt_local.breakindent = not vim.opt_local.breakindent:get()
end, { desc = 'Toggle line wrapping' })

user_command('CursorNode', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
    if not ok then
        vim.notify('No Tree-sitter parser for this buffer', vim.log.levels.ERROR)
        return
    end
    local tree = parser:parse(true)[1]
    local node = vim.treesitter.get_node { bufnr = bufnr, ignore_injections = false }
    if not node then
        vim.notify('No node under the cursor', vim.log.levels.INFO)
        return
    end
    local node_text
    if node == tree:root() then
        node_text = 'Root node'
    else
        local max_width = 200
        local text = vim.treesitter.get_node_text(node, bufnr)
        if #text > max_width then
            text = text:sub(1, max_width - 1) .. '…'
        end
        node_text = ('"%s"'):format(text)
    end
    local language = parser:language_for_range({ node:range() }):lang()
    vim.api.nvim_echo({
        { '[', '@punctuation.bracket' },
        { language, '@module' },
        { '] (', '@punctuation.bracket' },
        { node:type(), '@variable.query' },
        { ') ', '@punctuation.bracket' },
        { node_text, '@string' },
    }, false, {})
end, { desc = [[Show '[parser_name] (node_name) "node_text"' for the Tree-sitter node under the cursor]] })
