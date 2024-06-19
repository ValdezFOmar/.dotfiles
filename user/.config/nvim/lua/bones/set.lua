vim.g.query_lint_on = { 'InsertLeave', 'TextChanged' }

vim.opt.guicursor = 'a:block-inverse'
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.shortmess = 'ltToOCFI'
vim.opt.foldenable = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.wrap = false
vim.opt.scrolloff = 8

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.formatoptions:append 'r'
vim.opt.formatoptions:append 'o'

vim.opt.incsearch = true
-- vim.opt.concealcursor = 'nc'
-- vim.opt.conceallevel = 2

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
