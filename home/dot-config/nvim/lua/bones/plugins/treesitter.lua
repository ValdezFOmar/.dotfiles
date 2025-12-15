local parsers = {
    -- Prefer up to date parsers instead of builtin ones
    'c',
    'lua',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',
    -- languages
    'bash',
    'just',
    'rust',
    'python',
    -- web
    'css',
    'html',
    'json',
    'javascript',
    'typescript',
    -- config
    'ini',
    'toml',
    'yaml',
    'kitty',
    'hyprlang',
    'editorconfig',
    -- git
    'diff',
    'gitignore',
    'gitcommit',
    'git_rebase',
    'git_config',
    -- injections
    'regex',
    'printf',
    'comment',
    'luap',
    'luadoc',
    'jsdoc',
}

---@type LazyPluginSpec[]
return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        config = function()
            local nvimts = require 'nvim-treesitter'
            local installed = {} ---@type table<string, boolean>
            for _, parser in ipairs(nvimts.get_installed 'parsers') do
                installed[parser] = true
            end
            for _, parser in ipairs(parsers) do
                if not installed[parser] then
                    nvimts.install(parsers, { summary = true })
                    break
                end
            end
        end,
    },
    {
        'tree-sitter-grammars/tree-sitter-test',
        ft = 'test',
        build = 'mkdir -p parser && tree-sitter build -o parser/test.so',
        init = function()
            vim.g.tstest_fullwidth_rules = false
            vim.g.tstest_rule_hlgroup = '@punctuation.delimiter'
        end,
    },
}
