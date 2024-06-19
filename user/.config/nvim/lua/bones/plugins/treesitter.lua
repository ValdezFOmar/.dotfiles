local PLUGIN = { 'nvim-treesitter/nvim-treesitter' }

PLUGIN.build = ':TSUpdate'

function PLUGIN.config()
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line:missing-fields
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
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
            -- misc
            'ini',
            'bash',
            'markdown',
            'markdown_inline',
            'gitignore',
            -- For injections
            'regex',
            'printf',
            'comment',
            'luap',
            'luadoc',
            'jsdoc',
        },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        auto_install = true,
        indent = {
            enable = true,
            disable = {
                'css', -- it messes up the indentation of comments
                'html', -- indenting issues when `head` and `body` tags are at the same level as `html`
            },
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }
end

return PLUGIN
