local PLUGIN = { 'nvim-telescope/telescope.nvim' }

PLUGIN.dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- faster fuzzy finder
}

function PLUGIN.config()
    local actions = require 'telescope.actions'
    local actions_layout = require 'telescope.actions.layout'
    local vimgrep_args = { unpack(require('telescope.config').values.vimgrep_arguments) }

    -- Allows `find_files` to list hidden files
    vim.list_extend(vimgrep_args, {
        '--hidden',
        '--glob',
        '!**/.git/*',
        '--glob',
        '!**/.venv/*',
        '--glob',
        '!**/node_modules/*',
    })

    local telescope = require 'telescope'
    telescope.setup {
        defaults = {
            -- winblend = 20, -- Transparency messes up icons sizes
            vimgrep_arguments = vimgrep_args,
            sorting_strategy = 'ascending',
            results_title = false,
            prompt_prefix = '❯ ',
            selection_caret = '❯ ',
            borderchars = {
                { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                prompt = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                results = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
            },
            layout_config = {
                prompt_position = 'top',
                width = 0.9,
                height = 0.9,
            },
            mappings = {
                i = {
                    ['<M-q>'] = actions.close,
                    ['<M-t>'] = actions.select_tab,
                    ['<M-k>'] = actions.move_selection_previous,
                    ['<M-j>'] = actions.move_selection_next,
                    ['<M-p>'] = actions_layout.toggle_preview,
                },
                n = {
                    q = actions.close,
                    t = actions.select_tab,
                    ['<M-p>'] = actions_layout.toggle_preview,
                },
            },
        },
        pickers = {
            find_files = {
                find_command = {
                    'rg',
                    '--files',
                    '--hidden',
                    '--glob',
                    '!**/.git/*',
                    '--glob',
                    '!**/.venv/*',
                    '--glob',
                    '!**/node_modules/*',
                },
            },
            buffers = {
                initial_mode = 'normal',
                jump_type = 'tab',
                ignore_current_buffer = true,
                sort_mru = true,
                mappings = {
                    n = {
                        D = actions.delete_buffer,
                    },
                },
            },
            lsp_references = { initial_mode = 'normal' },
            lsp_definitions = { initial_mode = 'normal' },
            lsp_type_definitions = { initial_mode = 'normal' },
            man_pages = {
                prompt_title = 'Manual',
                previewer = false,
                layout_config = { width = 0.7, height = 0.6 },
            },
            help_tags = {
                previewer = false,
                layout_config = { width = 0.6, height = 0.6 },
            },
        },
    }
    telescope.load_extension 'fzf'

    local builtin = require 'telescope.builtin'

    local function search_in_repo()
        local prompt = vim.fs.basename(vim.fn.getcwd()) .. '❯ '
        local in_git_repo = pcall(builtin.git_files, { prompt_prefix = prompt })
        if not in_git_repo then
            vim.notify('You are not in a git repository.', vim.log.levels.ERROR)
        end
    end

    local function search_pattern()
        vim.ui.input({ prompt = 'Grep❯ ' }, function(pattern)
            if not pattern or pattern == '' then
                return
            end
            builtin.grep_string { search = pattern }
        end)
    end

    local map = vim.keymap.set
    map('n', '<leader>pf', builtin.find_files, { desc = 'Find files in the root directory' })
    map('n', '<leader>pg', search_in_repo, { desc = 'Find files tracked by git' })
    map('n', '<leader>ps', search_pattern, { desc = 'Search for pattern in files' })
    map('n', '<leader>pb', builtin.buffers, { desc = 'Lists open buffers in current instance' })
    map('n', '<leader>?', builtin.help_tags, { desc = 'Search for vim help' })
    map('n', '<M-a>', builtin.man_pages)
end

return PLUGIN
