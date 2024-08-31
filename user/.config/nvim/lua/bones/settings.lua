vim.g.query_lint_on = { 'InsertLeave', 'TextChanged' }

vim.opt.cursorline = true
vim.opt.guicursor = {
    'a:blinkwait700-blinkon250-blinkoff400',
    'i-ci-ve:ver25-Cursor/lCursor',
    'n-v-c:block-inverse',
    'o:hor50-Cursor/lCursor',
    'r-cr:hor20-Cursor/lCursor',
    'sm:block-blinkwait175-blinkoff150-blinkon175',
}

vim.opt.shortmess:append 'I'
vim.opt.incsearch = true
vim.opt.foldenable = false
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 8
vim.opt.virtualedit = { 'block' }

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.formatoptions:append 'r'
vim.opt.formatoptions:append 'o'

-- This settings would be useful if not for the fact
-- that it spell check a lot of files that should not
-- be spelled checked. I'll wait until nvim-treesitter 1.0
-- release since I'll have to implement my own autocmd
-- to start tree-sitter and there I can activate this
-- options, since tree-sitter buffers seems to have more
-- appropriate spellchecking (or at least not as faulty).
--vim.opt.spell = true
--vim.opt.spelllang = 'en'
--
vim.opt.linebreak = true
vim.opt.breakindent = true

--- LSP ---
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
vim.api.nvim_set_hl(0, '@lsp.type.fieldName', { link = '@variable.member' })

--- Diagnostics ---
local diagnostic_icons = {
    [vim.diagnostic.severity.ERROR] = ' ',
    [vim.diagnostic.severity.WARN] = ' ',
    [vim.diagnostic.severity.INFO] = ' ',
    [vim.diagnostic.severity.HINT] = ' ',
}

vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded' },
    signs = { text = diagnostic_icons },
    virtual_text = {
        prefix = function(diagnostic)
            local bufnr = diagnostic.bufnr
            if bufnr and vim.bo[bufnr].filetype == 'lazy' then
                return ''
            end
            return diagnostic_icons[diagnostic.severity]
        end,
    },
}

--- File types ---
vim.filetype.add {
    extension = {
        h = 'c',
        hook = 'ini',
        theme = 'ini',
        tex = 'tex',
    },
    filename = {
        ['.dmrc'] = 'ini',
        ['.megarc'] = 'ini',
        ['dunstrc'] = 'ini',
        ['picom.conf'] = 'conf',
        ['requirements.txt'] = 'requirements',
        ['requirements-dev.txt'] = 'requirements',
        ['dev-requirements.txt'] = 'requirements',
    },
    pattern = {
        ['.*/templates/.*%.html'] = 'htmldjango',
        ['%.?[Jj]ustfile'] = 'just',
    },
}

--- Tree-sitter ---
vim.treesitter.language.register('ini', 'systemd')
vim.treesitter.language.register('latex', 'plaintex')
