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

vim.filetype.add {
    extension = {
        conf = 'ini',
        hook = 'ini',
        theme = 'ini',
        tex = 'tex',
    },
    filename = {
        ['picom.conf'] = 'conf',
        ['dunstrc'] = 'ini',
        ['.dmrc'] = 'ini',
        ['.megarc'] = 'ini',
        ['requirements.txt'] = 'requirements',
        ['requirements-dev.txt'] = 'requirements',
        ['dev-requirements.txt'] = 'requirements',
    },
    pattern = {
        ['.*/templates/.*%.html'] = 'htmldjango',
        ['%.?[Jj]ustfile'] = 'just',
    },
}

--- LSP ---

vim.diagnostic.config { severity_sort = true, float = { border = 'rounded' } }
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

vim.api.nvim_set_hl(0, '@lsp.type.fieldName', { link = '@variable.member' })

--- Tree-sitter ---

vim.treesitter.language.register('ini', 'systemd')
vim.treesitter.language.register('latex', 'plaintex')
