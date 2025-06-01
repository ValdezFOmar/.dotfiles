local uri = require 'bones.uri'

local fs = vim.fs
local fn = vim.fn
local api = vim.api
local lsp = vim.lsp
local ms = lsp.protocol.Methods
local map = vim.keymap.set
local autocmd = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local command = api.nvim_create_user_command

local ui = {
    border = 'rounded',
    max_width = 80,
    max_height = 15,
}

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
vim.g.tex_flavor = 'latex' -- Recognize .tex files as LaTeX

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- BUG:
-- Telescope does not support this option yet.
-- Once it supports it, uncomment and remove references of ui.border.
-- vim.o.winborder = 'rounded'
vim.o.laststatus = 3
vim.o.cursorline = true
vim.o.guicursor = table.concat({
    -- idle cursor in normal mode and blinking in any other mode
    'a:blinkwait700-blinkon400-blinkoff250',
    'n:blinkon0',
    'n-v-c:block-inverse',
    'r-cr:hor20-Cursor/lCursor',
    'i-ci-ve:ver25-Cursor/lCursor',
    'o:hor50-Cursor/lCursor',
    'sm:block-blinkwait175-blinkoff150-blinkon175',
}, ',')

vim.o.title = true
vim.o.titlestring = '%t - NVIM'
vim.o.shortmess = vim.o.shortmess .. 'I'
vim.o.incsearch = true
vim.o.inccommand = 'split'
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 3
vim.o.signcolumn = 'yes:1'
vim.o.fillchars = 'eob:·'
vim.o.scrolloff = 8
vim.o.sidescrolloff = 10
vim.o.virtualedit = 'block'

vim.o.foldtext = ''
vim.o.foldlevel = 99
vim.o.foldenable = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.formatoptions = vim.o.formatoptions .. 'ro'

vim.o.linebreak = true
vim.o.breakindent = true
vim.o.breakindentopt = 'list:3'

--- Diagnostics ---
local diagnostic_icons = {
    [vim.diagnostic.severity.ERROR] = ' ',
    [vim.diagnostic.severity.WARN] = ' ',
    [vim.diagnostic.severity.INFO] = ' ',
    [vim.diagnostic.severity.HINT] = ' ',
}

vim.diagnostic.config {
    severity_sort = true,
    float = {
        source = 'if_many',
        border = ui.border,
        max_width = ui.max_width,
    },
    signs = {
        text = diagnostic_icons,
        numhl = {
            [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
            [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
            [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        },
    },
    virtual_lines = {
        current_line = true,
        format = function(diagnostic)
            local icon = diagnostic_icons[diagnostic.severity]
            return icon .. ' ' .. diagnostic.message
        end,
    },
}

--- File types ---
vim.filetype.add {
    extension = {
        h = 'c',
        hl = 'hyprlang',
        hook = 'confini',
        theme = 'desktop',
    },
    pattern = {
        ['.*/templates/.*%.html'] = 'htmldjango',
        ['.*ignore'] = 'ignore',
    },
}

--- Tree-sitter ---
for lang, ft in pairs {
    editorconfig = 'unixini', -- made up filetype to allow keys outside sections
    gitignore = 'ignore',
    diff = 'git',
    ini = 'systemd',
    vimdoc = 'checkhealth',
} do
    vim.treesitter.language.register(lang, ft)
end

--- Keymaps ---
map('n', '<leader>xx', '<Cmd>silent !chmod u+x %<Enter>')
map('n', 'gx', uri.open, { desc = 'Open a URI like `gx`, but better' })

-- copy/paste
map('n', '<C-a>', 'mzggVG', { desc = 'Select all text' })
map('x', '<leader>p', '"_dP', { desc = 'Keep yanked text after pasting' })
map('n', '<leader>Y', '"+Y', { desc = 'Copy line to clipboard' })
map('x', '<leader>Y', '"+y', { desc = 'Copy selected text to clipboard' })
map('n', 'yc', '<Cmd>let @+=@@<CR>', { desc = 'Copy unnamed register to clipboard' })
map({ 'n', 'x' }, '<leader>P', [["+p]], { desc = 'Paste from clipboard' })

-- editor
map('n', 'L', vim.diagnostic.open_float)
-- map('n', 'gs', vim.show_pos) map it to something more useful
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', '<M-n>', '<Cmd>cnext<Enter>', { desc = 'Next error in quickfix' })
map('n', '<M-p>', '<Cmd>cNext<Enter>', { desc = 'Previous error in quickfix' })
map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Go to Normal mode in Terminal' })
map({ 'n', 'v', 'i' }, '<C-z>', '<Nop>', { desc = "Dont't send neovim to the background" })

-- text editing
map('n', 'U', '<C-r>', { desc = 'Redo changes with `U`' })
map('n', 'J', 'mzJ`z', { desc = 'Same as `J`, but does not move the cursor' })

-- indentation
map('n', '<BS>', '<<', { desc = 'Remove 1 level of indentation' })
map('x', '<BS>', '<gv', { desc = 'Remove 1 level of indentation' })
map('x', '<Tab>', '>gv', { desc = 'Add 1 level of indentation' })

-- tabs
map('n', '<M-h>', '<Cmd>tabprevious<Enter>')
map('n', '<M-l>', '<Cmd>tabnext<Enter>')
map('n', '<M-H>', '<Cmd>tabmove-<Enter>')
map('n', '<M-L>', '<Cmd>tabmove+<Enter>')

--- LSP ---

lsp.config('basedpyright', {
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
                typeCheckingMode = 'standard',
            },
        },
    },
})

lsp.config('ts_query_ls', {
    settings = {
        parser_install_directories = {
            fs.joinpath(fn.getcwd(), 'parser'), -- useful for developing parsers
            fs.joinpath(fn.stdpath 'data', 'site', 'parser'), -- nvim-treesitter
            fs.joinpath(vim.env.VIMRUNTIME, 'parser'), -- bundled parsers
        },
    },
})

lsp.enable {
    'basedpyright',
    'bashls', -- needs 'shellcheck' and 'shfmt'
    'cssls',
    'emmet_language_server',
    'eslint',
    'html',
    'jsonls',
    'lua_ls',
    'marksman',
    'ruff',
    'rust_analyzer',
    'texlab',
    'ts_ls',
    'ts_query_ls',
}

---Utility for monkey patching default `vim.lsp.buf` functions.
---@param overriden fun(t: table|nil): any
---@param custom_opts table
---@return fun(t: table|nil): any
local function with(overriden, custom_opts)
    return function(opts)
        if not opts then
            return overriden(custom_opts)
        end
        return overriden(vim.tbl_deep_extend('force', custom_opts, opts))
    end
end

lsp.buf.hover = with(lsp.buf.hover, ui)
lsp.buf.signature_help = with(lsp.buf.signature_help, ui)

api.nvim_set_hl(0, '@lsp.type.fieldName', { link = '@variable.member' })

autocmd('LspAttach', {
    group = augroup('BonesLSPKeyMaps', {}),
    desc = 'Lsp Key Mappings',
    callback = function(ev)
        local client = assert(lsp.get_client_by_id(ev.data.client_id))
        local opts = { buffer = ev.buf }

        if client:supports_method(ms.textDocument_signatureHelp) then
            map({ 'n', 'i' }, '<C-H>', lsp.buf.signature_help, opts)
        end
        if client:supports_method(ms.textDocument_rename) then
            map({ 'n', 'i' }, '<F2>', lsp.buf.rename, opts)
        end
        if client:supports_method(ms.textDocument_formatting) then
            map({ 'n', 'v' }, '<F3>', lsp.buf.format, opts)
        end
        if client:supports_method(ms.textDocument_codeAction) then
            map({ 'n', 'i' }, '<F4>', lsp.buf.code_action, opts)
        end

        -- Use Telescope if available, else use neovim native implementations
        local ok, builtin = pcall(require, 'telescope.builtin')
        local definition = ok and builtin.lsp_definitions or lsp.buf.definition
        local type_definition = ok and builtin.lsp_type_definitions or lsp.buf.type_definition
        local references = ok and builtin.lsp_references or lsp.buf.references

        if client:supports_method(ms.textDocument_definition) then
            map('n', 'gd', definition, opts)
        end
        if client:supports_method(ms.textDocument_typeDefinition) then
            map('n', 'gt', type_definition, opts)
        end
        if client:supports_method(ms.textDocument_references) then
            map('n', 'gr', references, opts)
        end
    end,
})

--- Autocommands & User commands ---

autocmd('FileType', {
    group = augroup('EnableTreesitterFeatures', {}),
    callback = function(ev)
        local bufnr = ev.buf

        if not pcall(vim.treesitter.start, bufnr) then
            return
        end

        local winid = fn.bufwinid(bufnr)
        local bo = vim.bo[bufnr]
        local wo = vim.wo[winid][0]

        wo.spell = bo.modifiable and bo.buftype == ''
        wo.foldmethod = 'expr'
        wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

        if pcall(require, 'nvim-treesitter') then
            bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

autocmd({ 'BufNewFile', 'BufRead' }, {
    group = augroup('InsertBlankLineMappings', {}),
    callback = function(ev)
        if fn.getcmdwintype() ~= '' then
            return -- Don't override <Enter> mappings when editing commands
        end
        local bufnr = ev.buf
        if not vim.bo[bufnr].modifiable then
            return
        end
        map('n', '<S-Enter>', 'O<Esc>0"_D', { buffer = bufnr })
        map('n', '<Enter>', 'o<Esc>0"_D', { buffer = bufnr })
    end,
})

autocmd('TextYankPost', {
    group = augroup('HighlightYank', {}),
    callback = function()
        vim.hl.on_yank { timeout = 800 }
    end,
})

command('ToggleDiagnostics', function()
    local filter = { bufnr = 0 }
    vim.diagnostic.enable(not vim.diagnostic.is_enabled(filter), filter)
end, { desc = 'Toggle diagnostics in current buffer' })

--- lazy.nvim ---
if vim.env.NO_PLUGINS then
    vim.cmd.colorscheme 'retrobox'
    return
end

local lazy = require 'bones.lazy'
local lazy_path = fs.joinpath(fn.stdpath 'data', 'lazy', 'lazy.nvim')
local ok, installed = pcall(lazy.install, lazy_path)

if ok and installed then
    vim.o.runtimepath = lazy_path .. ',' .. vim.o.runtimepath

    ---@diagnostic disable-next-line:missing-fields
    require('lazy').setup('bones.plugins', {
        rocks = { enabled = false },
        git = { cooldown = 60 * 5 }, -- 5 minutes cooldown
        install = {
            colorscheme = { 'catppuccin-mocha', 'default' },
        },
        ui = {
            title = 'lazy.nvim 󰒲 ',
            border = ui.border,
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

    local lazyns = api.nvim_create_namespace 'lazy'
    vim.diagnostic.config({ virtual_text = { prefix = '' } }, lazyns)
end
