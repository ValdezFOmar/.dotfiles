local PLUGIN = { 'Issafalcon/lsp-overloads.nvim' }

-- I only use this plugin for C#
PLUGIN.lazy = true
PLUGIN.ft = 'cs'

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('LspOverloadsSignature', {}),
    desc = 'See function signature overloads',
    pattern = '*.cs',
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local provides_signature = client and client.server_capabilities.signatureHelpProvider

        if not provides_signature then
            return
        end

        ---@diagnostic disable:missing-fields
        require('lsp-overloads').setup(client, {
            ui = { border = 'rounded' },
            keymaps = { close_signature = '<M-o>' },
            display_automatically = false,
        })

        local opts = { noremap = true, silent = true, buffer = event.buf }
        vim.keymap.set({ 'i', 'n' }, '<M-o>', '<cmd>LspOverloadsSignature<CR>', opts)
    end,
})

return PLUGIN
