local ui = require 'bones.ui'

local fs = vim.fs
local fn = vim.fn
local api = vim.api
local lsp = vim.lsp
local map = vim.keymap.set
local autocmd = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local command = api.nvim_create_user_command

-- Replace UI components
vim.ui.select = ui.select

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

vim.o.winborder = 'rounded'
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
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 3
vim.o.signcolumn = 'yes:1'
vim.o.list = true
vim.o.listchars = 'trail:⌷,tab:⟩ '
vim.o.fillchars = 'eob:·'
vim.o.scrolloff = 8
vim.o.sidescrolloff = 10
vim.o.virtualedit = 'block'

vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.inccommand = 'split'

vim.o.foldtext = ''
vim.o.foldlevel = 99
vim.o.foldenable = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.formatoptions = vim.o.formatoptions .. 'ro'
vim.o.backspace = 'indent,eol,start,nostop'

vim.o.linebreak = true
vim.o.breakindent = true
vim.o.breakindentopt = 'list:3'

--- Keymaps ---

-- copy/paste
map('x', '<leader>y', '"+y', { desc = 'Copy selection to clipboard' })
map('n', '<leader>y', '"+yy', { desc = 'Copy line to clipboard' })
map('n', '<leader>Y', '"+y$', { desc = 'Copy until the EOL to clipboard' })
map('n', 'yc', '<CMD>let @+=@@<CR>', { desc = 'Copy unnamed register to clipboard' })
map('n', 'yp', '<CMD>let @@=expand("%:p")<CR>', { desc = "Copy current file's path" })
map({ 'n', 'x' }, '<leader>P', '"+p', { desc = 'Paste from clipboard' })

-- editor
map('n', 'L', vim.diagnostic.open_float)
map('n', 'gs', '<Nop>') -- map it to something more useful
map('n', 'z=', ui.spell, { desc = 'Show and select spell suggestions' })
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', '<M-n>', '<CMD>cnext<CR>', { desc = 'Next error in quickfix' })
map('n', '<M-p>', '<CMD>cNext<CR>', { desc = 'Previous error in quickfix' })
map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Go to Normal mode in Terminal' })

-- text editing
map('n', 'U', '<C-r>', { desc = 'Redo changes with `U`' })
map('n', 'J', 'mzJ`z', { desc = 'Same as `J`, but does not move the cursor' })
map('i', '<C-m>', require('bones.caps').toggle, { desc = 'Uppercase characters as you type' })

-- indentation
map('n', '<BS>', '<<', { desc = 'Remove 1 level of indentation' })
map('x', '<BS>', '<gv', { desc = 'Remove 1 level of indentation' })
map('x', '<Tab>', '>gv', { desc = 'Add 1 level of indentation' })

-- tabs
map('n', '<M-h>', '<CMD>tabprevious<CR>', { desc = 'Change focus to the left tab' })
map('n', '<M-l>', '<CMD>tabnext<CR>', { desc = 'Change to focus to the right tab' })
map('n', '<M-H>', '<CMD>tabmove -1<CR>', { desc = 'Move tab to the left' })
map('n', '<M-L>', '<CMD>tabmove +1<CR>', { desc = 'Move tab to the right' })

--- Diagnostics ---
local diagnostic_icons = {
    [vim.diagnostic.severity.INFO] = ' ',
    [vim.diagnostic.severity.HINT] = ' ',
    [vim.diagnostic.severity.WARN] = ' ',
    [vim.diagnostic.severity.ERROR] = ' ',
}

vim.diagnostic.config {
    severity_sort = true,
    float = {
        source = 'if_many',
        max_width = ui.defaults.max_width,
    },
    signs = {
        text = diagnostic_icons,
        numhl = {
            [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
            [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
            [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
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
    filename = {
        ['kitty.conf'] = 'kitty',
    },
    extension = {
        h = 'c',
        hl = 'hyprlang',
        hook = 'confini',
        theme = 'desktop',
    },
    pattern = {
        ['.*/templates/.*%.html'] = 'htmldjango',
        ['.*/kitty/.*%.conf'] = 'kitty',
        ['%.*ignore'] = 'ignore',
    },
}

--- Tree-sitter ---
do
    for lang, ft in pairs {
        editorconfig = 'unixini', -- made up filetype to allow keys outside sections
        gitignore = 'ignore',
        diff = 'git',
        ini = 'systemd',
        vimdoc = 'checkhealth',
    } do
        vim.treesitter.language.register(lang, ft)
    end

    local cache = {} ---@type table<string, boolean?>

    ---@param lang string
    ---@param query string
    ---@return boolean
    local function has_query(lang, query)
        local path = fs.joinpath('queries', lang, query)
        if cache[path] == nil then
            cache[path] = #api.nvim_get_runtime_file(path, true) > 0
        end
        return cache[path]
    end

    local MAX_FILE_SIZE = 500 * 1024 -- 500 KB

    -- Created before enabling any LSP config,
    -- allowing `LspAttach` event to override some features set here.
    autocmd('FileType', {
        desc = 'Enable Tree-sitter features',
        group = augroup('bones.treesitter', {}),
        callback = function(ev)
            local stats = vim.uv.fs_stat(api.nvim_buf_get_name(ev.buf))
            if stats and stats.size > MAX_FILE_SIZE then
                return
            end

            if not pcall(vim.treesitter.start, ev.buf) then
                return
            end

            local lang = vim.treesitter.get_parser(ev.buf):lang()
            local bo = vim.bo[ev.buf]
            local wo = vim.wo[0][0]

            if not wo.spell then
                wo.spell = bo.modifiable and bo.buftype == ''
            end

            if has_query(lang, 'folds.scm') then
                wo.foldmethod = 'expr'
                wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            end

            if pcall(require, 'nvim-treesitter') and has_query(lang, 'indents.scm') then
                bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })
end

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
    'eslint',
    'html',
    'jsonls',
    'lua_ls',
    'marksman',
    'ruff',
    'rust_analyzer',
    'ts_ls',
    'ts_query_ls',
}

autocmd('LspAttach', {
    group = augroup('bones.lsp', {}),
    desc = 'Set LSP mappings and options',
    callback = function(ev)
        local client = assert(lsp.get_client_by_id(ev.data.client_id))
        local opts = { buffer = ev.buf }

        if client:supports_method 'textDocument/foldingRange' then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldmethod = 'expr'
            vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end

        if client:supports_method 'textDocument/hover' then
            map('n', 'K', function()
                lsp.buf.hover(ui.defaults)
            end, opts)
        end
        if client:supports_method 'textDocument/signatureHelp' then
            map({ 'i', 's' }, '<C-S>', function()
                lsp.buf.signature_help(ui.defaults)
            end, opts)
        end
        if client:supports_method 'textDocument/formatting' then
            map('n', 'grq', lsp.buf.format, opts) -- use `gq` in Visual mode
        end

        -- Use fzf-lua if available, else use neovim native implementations
        local ok, fzf = pcall(require, 'fzf-lua')
        local definition = ok and fzf.lsp_definitions or lsp.buf.definition
        local type_definition = ok and fzf.lsp_typedefs or lsp.buf.type_definition
        local references = ok and fzf.lsp_references or lsp.buf.references

        if client:supports_method 'textDocument/definition' then
            map('n', 'gd', definition, opts)
        end
        if client:supports_method 'textDocument/typeDefinition' then
            map('n', 'gt', type_definition, opts)
        end
        if client:supports_method 'textDocument/references' then
            map('n', 'grr', references, opts)
        end
    end,
})

--- Auto commands & User commands ---

autocmd('CmdwinEnter', {
    group = augroup('bones.cmdwin', {}),
    desc = 'Disable line numbers and signcolumn',
    callback = function()
        vim.wo[0][0].number = false
        vim.wo[0][0].relativenumber = false
        vim.wo[0][0].signcolumn = 'auto'
    end,
})

autocmd({ 'BufNewFile', 'BufRead' }, {
    group = augroup('bones.enter-blank', {}),
    desc = 'Mappings for inserting a blank line',
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
    group = augroup('bones.yank', {}),
    callback = function()
        vim.hl.on_yank { timeout = 400 }
    end,
})

command('ToggleDiagnostics', function()
    local filter = { bufnr = 0 }
    vim.diagnostic.enable(not vim.diagnostic.is_enabled(filter), filter)
end, { desc = 'Toggle diagnostics in current buffer' })

command('Executable', function()
    local bit = require 'bit'
    local path = fn.expand '%:p'
    local notify = vim.schedule_wrap(vim.notify)

    local stat, err = vim.uv.fs_stat(path)
    if not stat then
        notify(err, vim.log.levels.ERROR)
        return
    end

    -- Add executable bit for file owner (like 'chmod u+x')
    local mode = bit.bor(stat.mode, tonumber('100', 8))
    local _, err = vim.uv.fs_chmod(path, mode)
    if err then
        notify(err, vim.log.levels.ERROR)
        return
    end

    local permissions = bit.band(mode, tonumber('777', 8))
    notify(('File "%s" is now executable (%o)'):format(fs.basename(path), permissions))
end, { desc = 'Make current file executable' })

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

    require('lazy').setup('bones.plugins', {
        rocks = { enabled = false },
        git = { cooldown = 60 * 5 }, -- 5 minutes cooldown
        install = {
            colorscheme = { 'catppuccin-mocha', 'default' },
        },
        ui = {
            title = 'lazy.nvim 󰒲 ',
            border = vim.o.winborder,
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
    vim.diagnostic.config({ virtual_text = { prefix = '⏺' } }, lazyns)
end
