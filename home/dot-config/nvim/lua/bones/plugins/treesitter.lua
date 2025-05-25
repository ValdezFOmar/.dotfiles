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
    'just',
    'rust',
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

---@type LazyPluginSpec[]
return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        branch = 'main', -- remove once 'main' becomes the default branch
        lazy = false,
        config = function()
            require('nvim-treesitter').install(parsers)
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
