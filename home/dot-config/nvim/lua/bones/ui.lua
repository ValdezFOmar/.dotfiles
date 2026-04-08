local api = vim.api

local M = {}

M.defaults = {
    max_width = 80,
    max_height = 15,
    anchor_bias = 'below',
}

---@class bones.ui.Size
---@field width integer
---@field height integer

---@class bones.ui.Layout
---@field col integer
---@field row integer
---@field width integer
---@field height integer

---Recalculate a window layout with the given max width/height constraint.
---Assumes the window has a `NW` anchor and has a border.
---@param target bones.ui.Size Ideal window size
---@param max bones.ui.Size Window size can't be greater than this
---@return bones.ui.Layout layout
local function new_layout(target, max)
    local container = { width = vim.o.columns, height = vim.o.lines - vim.o.cmdheight }
    -- subtract 2 to account for 1 cell border width on each side
    local width = math.max(1, math.min(target.width, max.width, container.width - 2))
    local height = math.max(1, math.min(target.height, max.height, container.height - 2))
    local col = math.floor((container.width - width) / 2) - 1
    local row = math.floor((container.height - height) / 2) - 1
    return { width = width, height = height, col = col, row = row }
end

---@param prompt string
---@return string
local function normalize_prompt(prompt)
    return (' %s '):format(vim.trim(prompt):gsub('\n', ' '):gsub(':$', ''))
end

local select_ns = api.nvim_create_namespace 'bones.ui.select'

---@type bones.ui.Size
local select_max_win_size = {
    width = M.defaults.max_width,
    height = M.defaults.max_height,
}

---@class bones.ui.CodeAction
---@field action lsp.Command|lsp.CodeAction
---@field ctx lsp.HandlerContext

---@class bones.ui.select.Opts
---@field kind? string
---@field prompt? string
---@field format_item? fun(item: any): string

---@generic T
---@param items T[]
---@param opts bones.ui.select.Opts
---@param on_choice fun(choice?: T, idx?: integer)
function M.select(items, opts, on_choice)
    vim.validate('items', items, 'table')
    vim.validate('opts', opts, 'table')
    vim.validate('opts.prompt', opts.prompt, 'string', true)
    vim.validate('opts.format_item', opts.format_item, 'callable', true)
    vim.validate('opts.kind', opts.kind, 'string', true)
    vim.validate('on_choice', on_choice, 'callable')

    local prompt = normalize_prompt(opts.prompt or 'Select one of')
    local format_item = opts.format_item or tostring

    local pad_width = string.len(#items)
    local lines = {} ---@type string[]
    local max_line_len = #prompt

    for index, item in ipairs(items) do
        local pad = (' '):rep(pad_width - string.len(index))
        local line = ('%s%d. %s'):format(pad, index, format_item(item)):gsub('\n', ' | ')
        lines[index] = line
        max_line_len = math.max(max_line_len, #line)
    end

    local buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(buf, 0, -1, true, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].readonly = true
    vim.treesitter.start(buf, 'markdown')

    if opts.kind == 'codeaction' then
        local space = 2 -- Spaces between the text and the client name
        for i, item in ipairs(items) do
            ---@cast item bones.ui.CodeAction
            local client = vim.lsp.get_client_by_id(item.ctx.client_id)
            if client then
                local name = client.config.name or client.name
                api.nvim_buf_set_extmark(buf, select_ns, i - 1, 0, {
                    virt_text = { { name, 'DiagnosticVirtualTextHint' } },
                    virt_text_pos = 'eol_right_align',
                    virt_lines_overflow = 'scroll',
                })
                -- Ideal length to fit both the text and client name
                local len = #lines[i] + space + #name
                max_line_len = math.max(max_line_len, len)
            end
        end
    end

    local win_size = { width = max_line_len, height = #items }
    local win = api.nvim_open_win(buf, true, {
        title = prompt,
        title_pos = 'center',
        relative = 'editor',
        row = 0,
        col = 0,
        width = 1,
        height = 1,
        anchor = 'NW',
        style = 'minimal',
        mouse = true,
        focusable = true,
    })
    vim.cmd.stopinsert()
    vim.wo[win][0].winfixbuf = true
    vim.wo[win][0].cursorline = true

    local function resize()
        local layout = new_layout(win_size, select_max_win_size)
        local footer = layout.height < #items and ('[%d items]'):format(#items) or nil
        api.nvim_win_set_config(win, {
            footer = footer,
            footer_pos = footer and 'center',
            relative = 'editor',
            col = layout.col,
            row = layout.row,
            width = layout.width,
            height = layout.height,
        })
    end
    resize()

    local function close()
        api.nvim_win_close(win, true)
    end

    local selected_index ---@type integer?
    local augroup = api.nvim_create_augroup('bones.ui.select-' .. win, { clear = true })

    api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(win),
        group = augroup,
        callback = function()
            pcall(api.nvim_del_augroup_by_id, augroup)
            pcall(api.nvim_buf_delete, buf, { force = true })
            if selected_index then
                on_choice(items[selected_index], selected_index)
            else
                on_choice(nil, nil)
            end
        end,
    })

    api.nvim_create_autocmd('VimResized', {
        group = augroup,
        callback = function()
            vim.schedule(resize)
        end,
    })

    vim.keymap.set('n', 'q', close, { buf = buf, nowait = true })
    vim.keymap.set('n', '<Esc>', close, { buf = buf, nowait = true })
    vim.keymap.set('n', '<Enter>', function()
        local row_index = api.nvim_win_get_cursor(win)[1]
        if row_index <= #items then
            selected_index = row_index
            close()
        end
    end, { buf = buf, nowait = true })
end

---@class bones.ui.input.Opts
---@field prompt? string
---@field default? string

---@param opts bones.ui.input.Opts?
---@param on_confirm fun(input: string?)
function M.input(opts, on_confirm)
    opts = opts or {}
    vim.validate('opts', opts, 'table', true)
    vim.validate('opts.prompt', opts.prompt, 'string', true)
    vim.validate('opts.default', opts.default, 'string', true)
    vim.validate('on_confirm', on_confirm, 'callable')

    local prompt = normalize_prompt(opts.prompt or 'Input')
    local max_line_len = math.max(#prompt, 30)

    local buf = api.nvim_create_buf(false, true)

    if opts.default then
        local lines = vim.split(opts.default, '\n')
        for _, line in ipairs(lines) do
            max_line_len = math.max(max_line_len, math.ceil(#line * 1.5))
        end
        api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end
    local win_size = { width = max_line_len, height = 1 }
    local win = api.nvim_open_win(buf, true, {
        title = prompt,
        title_pos = 'left',
        relative = 'editor',
        row = 0,
        col = 0,
        width = 1,
        height = 1,
        anchor = 'NW',
        style = 'minimal',
        mouse = true,
        focusable = true,
    })
    vim.wo[win][0].winfixbuf = true
    vim.wo[win][0].sidescrolloff = 2
    vim.cmd.startinsert { bang = true }

    local function resize()
        local layout = new_layout(win_size, { width = 60, height = 1 })
        local count = api.nvim_buf_line_count(buf)
        local footer = layout.height < count and ('[%d lines]'):format(count) or nil
        api.nvim_win_set_config(win, {
            footer = footer,
            footer_pos = footer and 'center',
            relative = 'editor',
            col = layout.col,
            row = layout.row,
            width = layout.width,
            height = layout.height,
        })
    end
    resize()

    local function close()
        api.nvim_win_close(win, true)
    end

    local augroup = api.nvim_create_augroup('bones.ui.input-' .. win, {})
    local input ---@type string?

    api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(win),
        group = augroup,
        callback = function()
            pcall(api.nvim_del_augroup_by_id, augroup)
            pcall(api.nvim_buf_delete, buf, { force = true })
            on_confirm(input)
        end,
    })

    api.nvim_create_autocmd('VimResized', {
        group = augroup,
        callback = function()
            vim.schedule(resize)
        end,
    })

    vim.keymap.set('n', 'q', close, { buf = buf, nowait = true })
    vim.keymap.set('n', '<Esc>', close, { buf = buf, nowait = true })
    vim.keymap.set({ 'n', 'i' }, '<Enter>', function()
        input = table.concat(api.nvim_buf_get_lines(buf, 0, -1, true), '\n')
        vim.cmd.stopinsert()
        close()
    end, { buf = buf, nowait = true })
end

local spell_on_choice = vim.schedule_wrap(function(_, i)
    if type(i) == 'number' then
        vim.cmd.normal { i .. 'z=', bang = true }
    end
end)

function M.spell()
    if vim.v.count > 0 then
        spell_on_choice(nil, vim.v.count)
        return
    end
    local word = vim.fn.expand '<cword>'
    vim.ui.select(
        vim.fn.spellsuggest(word),
        { prompt = ('Change "%s" to'):format(word) },
        spell_on_choice
    )
end

return M
