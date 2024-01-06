local PLUGIN = { "nvim-telescope/telescope.nvim" }

PLUGIN.branch = "0.1.x"

PLUGIN.dependencies = {
  "nvim-lua/plenary.nvim",
  "BurntSushi/ripgrep",
}

function PLUGIN.config()
  local actions = require "telescope.actions"
  local actions_layout = require "telescope.actions.layout"
  local vimgrep_args = { unpack(require "telescope.config".values.vimgrep_arguments) }

  -- Allows `find_files` to list hidden files, but still ignore diectories
  table.insert(vimgrep_args, "--hidden")
  table.insert(vimgrep_args, "--glob")
  table.insert(vimgrep_args, "!**/.git/*")
  table.insert(vimgrep_args, "--glob")
  table.insert(vimgrep_args, "!**/.venv/*")

  require "telescope".setup {
    defaults = {
      -- winblend = 20, -- Transparency messes up icons sizes
      vimgrep_arguments = vimgrep_args,
      sorting_strategy = "ascending",
      results_title = false,
      -- dynamic_preview_title = true,
      prompt_prefix = "❯ ",
      selection_caret = "❯ ",
      borderchars = {
        { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        prompt  = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
      layout_config = {
        prompt_position = "top",
        width = 0.9,
        height = 0.9,
      },
      mappings = {
        i = {
          ["<leader>q"] = actions.close,
          ["<leader>h"] = actions.which_key,
          ["<leader>t"] = actions.select_tab,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-j>"] = actions.move_selection_next,
          ["<M-p>"] = actions_layout.toggle_preview,
          ["<M-t>"] = actions_layout.toggle_prompt_position,
        },
        n = {
          ["<leader>q"] = actions.close,
          ["q"] = actions.close,
          ["h"] = actions.which_key,
          ["t"] = actions.select_tab,
          ["<M-p>"] = actions_layout.toggle_preview,
          ["<M-t>"] = actions_layout.toggle_prompt_position,
        },
      },
    },
    pickers = {
      find_files = {
        find_command = {
          "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--glob", "!**/.venv/*"
        },
      },
      buffers = {
        initial_mode = "normal",
        jump_type = "tab",
        ignore_current_buffer = true,
        sort_mru = true,
      },
      git_status = { initial_mode = "normal" },
      diagnostics = { initial_mode = "normal" },
      lsp_references = { initial_mode = "normal" },
      lsp_definitions = { initial_mode = "normal" },
      lsp_type_definitions = { initial_mode = "normal" },
      man_pages = {
        prompt_title = "Manual",
        previewer = false,
        layout_config = { width = 0.7, height = 0.6 },
      },
      help_tags = {
        previewer = false,
        layout_config = { width = 0.6, height = 0.6 },
      },
    }
  }

  local builtin = require "telescope.builtin"

  local function search_in_repo()
    local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local in_git_repo = pcall(builtin.git_files, { prompt_prefix = cwd .. "❯ " })
    if not in_git_repo then
      vim.notify("You are not in a git repository.", vim.log.levels.INFO)
    end
  end

  local function search_pattern()
    local pattern = vim.fn.input("Grep ❯ ")
    if #pattern == 0 then return end
    builtin.grep_string({ search = pattern })
  end

  local function current_diagnostics()
    builtin.diagnostics({ bufnr = 0 })
  end

  local function file_siblings()
    builtin.find_files({
      prompt_title = "File Sibligs",
      initial_mode = "normal",
      cwd = vim.fn.expand("%:p:h"),
    })
  end

  local remap = vim.keymap.set
  remap("n", "<leader>pf", builtin.find_files, { desc = "Find files in the root directory" })
  remap("n", "<leader>fs", file_siblings, { desc = "Lists siblings of current file" })
  remap("n", "<leader>pg", search_in_repo, { desc = "Find files tracked by git" })
  remap("n", "<leader>ps", search_pattern, { desc = "Search for pattern in files" })
  remap("n", "<leader>pd", builtin.diagnostics, { desc = "LSP diagnostics for all open buffers" })
  remap("n", "<leader>ld", current_diagnostics, { desc = "LSP diagnostics for current buffer" })
  remap("n", "<leader>lb", builtin.buffers, { desc = "Lists open buffers in current instance" })
  remap("n", "<leader>ts", builtin.treesitter, { desc = "Lists functions and variables in buffer" })
  remap("n", "<leader>fz", builtin.current_buffer_fuzzy_find)
  remap("n", "<leader>gs", builtin.git_status)
  remap("n", "<leader>lr", builtin.lsp_references)
  remap("n", "<leader>gt", builtin.lsp_type_definitions)
  remap("n", "<leader>?", builtin.help_tags, { desc = "Search for vim help" })
  remap("n", "<M-a>", builtin.man_pages)

  -- keymap("n", "<leader>lv", builtin.live_grep)
end

return PLUGIN
