vim.opt.guicursor = 'a:block-inverse'
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.shortmess = 'ltToOCFI'
vim.opt.foldenable = false

vim.opt.number = true
vim.opt.relativenumber = true
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

vim.diagnostic.config { severity_sort = true }

vim.filetype.add {
    extension = {
        conf = 'ini',
        hook = 'ini',
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

--[[
TODO: add highlight groups for C# doc comments

Omnisharp reports semantic tokens in the form of `@lsp.type.xmlDocument*`,
so this highlight groups should be linked to a tag highlight groups (like `@tag.*`)

A complete list of all the semantic tokens can be found at
https://github.com/dotnet/roslyn/src/Workspaces/Core/Portable/Classification/ClassificationTypeNames.cs#L57C8-L77C24

/// <summary>
/// Some description <c>Program</c>
/// </summary>
--]]
vim.api.nvim_set_hl(0, '@lsp.type.fieldName', { link = '@variable.member' })
