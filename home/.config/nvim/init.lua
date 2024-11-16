local uri = require 'bones.uri'

local api = vim.api
local lsp = vim.lsp
local map = vim.keymap.set
local autocmd = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local user_command = api.nvim_create_user_command

-- Old language providers are slow, disable them:
-- https://github.com/neovim/neovim/issues/7063#issuecomment-2382641641
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Disabled because is very slow and blocks the editor,
-- use https://github.com/ribru17/ts_query_ls instead
vim.g.query_lint_on = {} -- { 'InsertLeave', 'TextChanged' }
vim.g.tex_flavor = 'latex' -- Recongize .tex files as LaTeX

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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
vim.opt.fillchars = 'eob:·'
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 10
vim.opt.virtualedit = { 'block' }

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.formatoptions:append 'r'
vim.opt.formatoptions:append 'o'

-- TODO: Wait until nvim-treesitter 1.0 release and enable spellchecking
-- after successfully calling `vim.treesitter.start()`.
-- TODO: Remove spellchech autocmd
--vim.opt.spell = true
--vim.opt.spelllang = 'en'

vim.opt.linebreak = true
vim.opt.breakindent = true

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
        rasi = 'rasi',
        theme = 'ini',
    },
    filename = {
        ['.dmrc'] = 'ini',
        ['.megarc'] = 'ini',
        ['dunstrc'] = 'ini',
        ['paru.conf'] = 'paru',
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
vim.treesitter.language.register('ini', { 'systemd' })
vim.treesitter.language.register('vimdoc', { 'checkhealth' })
vim.treesitter.language.register('editorconfig', { 'paru' })

--- Keymaps ---
map('n', '<leader>xx', '<Cmd>silent !chmod u+x %<Enter>')
map('n', 'gx', uri.open, { desc = 'Open a URI like `gx`, but better' })

-- copy/paste
map('n', '<C-a>', 'mzggVG', { desc = 'Select all text' })
map('x', '<leader>p', [["_dP]], { desc = 'Keep yanked text after pasting' })
map('n', '<leader>Y', [["+Y]], { desc = 'Copy line to clipboard' })
map('x', '<leader>Y', [["+y]], { desc = 'Copy selected text to clipboard' })
map({ 'n', 'x' }, '<leader>P', [["+p]], { desc = 'Paste from clipboard' })

-- editor
map('n', 'L', vim.diagnostic.open_float)
map('n', '<leader>w', '<Cmd>silent write<Enter>')
map('n', '<leader>q', '<Cmd>quit<Enter>')
map('n', '<M-n>', '<Cmd>cnext<Enter>', { desc = 'Next error in quickfix' })
map('n', '<M-p>', '<Cmd>cNext<Enter>', { desc = 'Previous error in quickfix' })
map({ 'n', 'v', 'i' }, '<C-z>', '<Nop>', { desc = "Dont't send neovim to the background" })

-- text editing
map('n', 'U', '<C-r>', { desc = 'Redo changes with `U`' })
map('n', 'J', 'mzJ`z', { desc = 'Same as `J`, but does not move the cursor' })

-- indentation
map('n', '<Tab>', '>>', { desc = 'Add 1 level of indentation' })
map('x', '<Tab>', '>gv', { desc = 'Add 1 level of indentation' })
map('n', '<S-Tab>', '<<', { desc = 'Remove 1 level of indentation' })
map('n', '<BS>', '<<', { desc = 'Remove 1 level of indentation' })
map('x', '<S-Tab>', '<gv', { desc = 'Remove 1 level of indentation' })
map('x', '<BS>', '<gv', { desc = 'Remove 1 level of indentation' })

-- tabs
map('n', '<M-h>', '<Cmd>tabprevious<Enter>')
map('n', '<M-l>', '<Cmd>tabnext<Enter>')
map('n', '<M-H>', '<Cmd>tabmove-<Enter>')
map('n', '<M-L>', '<Cmd>tabmove+<Enter>')

--- LSP ---
local lsp_opts = { border = 'rounded' }

lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, lsp_opts)
lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, lsp_opts)
api.nvim_set_hl(0, '@lsp.type.fieldName', { link = '@variable.member' })

autocmd('LspAttach', {
    group = augroup('BonesLSPKeyMaps', {}),
    desc = 'Lsp Key Mappings',
    callback = function(event)
        local client = assert(lsp.get_client_by_id(event.data.client_id))
        local opts = { buffer = event.buf }

        if client.supports_method 'textDocument/rename' then
            map({ 'n', 'i' }, '<F2>', lsp.buf.rename, opts)
        end
        if client.supports_method 'textDocument/formatting' then
            map({ 'n', 'v' }, '<F3>', lsp.buf.format, opts)
        end
        if client.supports_method 'textDocument/codeAction' then
            map({ 'n', 'i' }, '<F4>', lsp.buf.code_action, opts)
        end

        -- Use Telescope if available, else use neovim native implementations
        local ok, builtin = pcall(require, 'telescope.builtin')
        local goto_definition = ok and builtin.lsp_definitions or lsp.buf.definition
        local goto_type_def = ok and builtin.lsp_type_definitions or lsp.buf.type_definition
        local show_references = ok and builtin.lsp_references or lsp.buf.references

        if client.supports_method 'textDocument/definition' then
            map('n', 'gd', goto_definition, opts)
        end
        if client.supports_method 'textDocument/typeDefinition' then
            map('n', 'gt', goto_type_def, opts)
        end
        if client.supports_method 'textDocument/references' then
            map('n', '<leader>lr', show_references, opts)
        end
    end,
})

--- Autocommands & User commands ---

--- TODO: remove when nvim-treesitter 1.0 is release
autocmd('FileType', {
    group = augroup('SpellCheckText', {}),
    pattern = { 'gitcommit', 'markdown', 'html' },
    callback = function()
        vim.opt_local.spell = true
    end,
})

autocmd({ 'BufNewFile', 'BufRead' }, {
    group = augroup('InsertBlankLineMappings', {}),
    callback = function(event)
        if vim.fn.getcmdwintype() ~= '' then
            return -- Don't override <Enter> mappings when editing commands
        end
        ---@type integer
        local bufnr = event.buf
        local bo = vim.bo[bufnr]
        if not bo.modifiable or bo.readonly then
            return
        end
        map('n', '<S-Enter>', 'mzO<Esc>0"_D`z', { buffer = bufnr })
        map('n', '<Enter>', 'mzo<Esc>0"_D`z', { buffer = bufnr })
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
    local filter = { bufnr = 0 }
    vim.diagnostic.enable(not vim.diagnostic.is_enabled(filter), filter)
end, { desc = 'Toggle diagnostics in current buffer' })

--- lazy.nvim ---
if vim.env.NO_PLUGINS then
    vim.cmd.colorscheme 'retrobox'
    return
end

local lazy_setup = require 'bones.lazy'
local ok, installed = pcall(lazy_setup.install)

if ok and installed then
    require('lazy').setup('bones.plugins', {
        rocks = { enabled = false },
        git = { cooldown = 60 * 5 }, -- 5 minutes cooldown
        install = {
            colorscheme = { 'catppuccin-mocha', 'default' },
        },
        ui = {
            title = 'lazy.nvim 󰒲 ',
            border = 'rounded',
        },
        checker = {
            enabled = true,
            concurrency = 4,
            notify = false,
        },
        -- This avoids an annoying prompt in all neovim instances
        change_detection = {
            enabled = false,
            notify = false,
        },
    })
end
