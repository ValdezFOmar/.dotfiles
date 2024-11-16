local parsers = {
    -- This 5 should always be installed
    'c',
    'lua',
    'vim',
    'vimdoc',
    'query',
    -- python
    'python',
    'toml',
    'htmldjango',
    -- web
    'html',
    'css',
    'json',
    'javascript',
    'typescript',
    -- git
    'gitignore',
    'gitcommit',
    'git_rebase',
    'git_config',
    'diff',
    -- misc
    'yaml',
    'ini',
    'bash',
    'markdown',
    'markdown_inline',
    'editorconfig',
    -- injections
    'regex',
    'printf',
    'comment',
    'luap',
    'luadoc',
    'jsdoc',
}

return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs',
        opts = {
            ensure_installed = parsers,
            sync_install = false,
            indent = {
                enable = true,
                disable = {
                    'css', -- it messes up the indentation of comments
                    -- indenting issues when `head` and `body` tags are at the same level as `html`
                    'html',
                    'htmldjango',
                },
            },
            highlight = {
                enable = true,
            },
        },
    },
    {
        'tree-sitter-grammars/tree-sitter-test',
        ft = 'test',
        build = 'make parser/test.so',
        init = function()
            vim.g.tstest_fullwidth_rules = false
            vim.g.tstest_rule_hlgroup = '@punctuation.delimiter'
        end,
    },
}
