local api = vim.api

local M = {}

M.defaults = {
    max_width = 80,
    max_height = 15,
    anchor_bias = 'below',
}

--- @class bones.ui.Dimensions
--- @field w integer width
--- @field h integer height

--- @class bones.ui.WinDimensions
--- @field col integer
--- @field row integer
--- @field width integer
--- @field height integer

--- @param dim bones.ui.Dimensions Target dimensions
--- @param max_dim bones.ui.Dimensions Maximum dimensions
--- @return bones.ui.WinDimensions dimensions Assume `NW` anchor
local function calc_dimensions(dim, max_dim)
    local width = math.max(1, math.min(dim.w, max_dim.w, vim.o.columns - 4)) -- 4 leaves a 1 cell gap with borders
    local height = math.max(1, math.min(dim.h, max_dim.h, vim.o.lines - 4))
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    return { width = width, height = height, row = row, col = col }
end

local select_ns = api.nvim_create_namespace 'bones.ui.select'
local select_max_dimensions = {
    w = M.defaults.max_width,
    h = M.defaults.max_height,
}

--- @class bones.ui.CodeAction
--- @field action lsp.Command|lsp.CodeAction
--- @field ctx lsp.HandlerContext

--- @class bones.ui.select.Opts
--- @field kind? string
--- @field prompt? string
--- @field format_item? fun(item: any): string

--- Replacement for `vim.ui.select()`, but using floating windows.
--- @generic T
--- @param items T[]
--- @param opts bones.ui.select.Opts
--- @param on_choice fun(choice?: T, idx?: integer)
function M.select(items, opts, on_choice)
    vim.validate('items', items, 'table')
    vim.validate('opts', opts, 'table')
    vim.validate('opts.prompt', opts.prompt, 'string', true)
    vim.validate('opts.format_item', opts.format_item, 'callable', true)
    vim.validate('opts.kind', opts.kind, 'string', true)
    vim.validate('on_choice', on_choice, 'callable')

    local prompt = (opts.prompt or 'Select one of'):gsub('\n', ' '):gsub(':%s*$', '')
    local format_item = opts.format_item or tostring

    local pad_width = string.len(#items)
    local lines = {} --- @type string[]
    local max_line_len = #prompt

    for index, item in ipairs(items) do
        local pad = (' '):rep(pad_width - string.len(index))
        local line = ('%s%d. %s'):format(pad, index, format_item(item)):gsub('\n', ' | ')
        lines[index] = line
        max_line_len = math.max(max_line_len, #line)
    end

    local bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].readonly = true
    vim.treesitter.start(bufnr, 'markdown')

    if opts.kind == 'codeaction' then
        local space = 2 -- Spaces between the text and the client name
        for i, item in ipairs(items) do
            --- @cast item bones.ui.CodeAction
            local client = vim.lsp.get_client_by_id(item.ctx.client_id)
            if client then
                local name = client.config.name or client.name
                api.nvim_buf_set_extmark(bufnr, select_ns, i - 1, 0, {
                    virt_text = { { name, '@comment' } },
                    virt_text_pos = 'eol_right_align',
                    virt_lines_overflow = 'scroll',
                })
                -- Ideal length to fit both the text and client name
                local len = #lines[i] + space + #name
                max_line_len = math.max(max_line_len, len)
            end
        end
    end

    local target_dimensions = { w = max_line_len, h = #items }
    local winid = api.nvim_open_win(bufnr, false, {
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
    vim.wo[winid][0].cursorline = true
    vim.wo[winid][0].conceallevel = 2
    vim.wo[winid][0].concealcursor = 'nc'

    local function resize()
        local dimensions = calc_dimensions(target_dimensions, select_max_dimensions)
        local footer = dimensions.height < #items and ('[%d]'):format(#items) or nil
        api.nvim_win_set_config(winid, {
            footer = footer,
            footer_pos = footer and 'center',
            relative = 'editor',
            col = dimensions.col,
            row = dimensions.row,
            width = dimensions.width,
            height = dimensions.height,
        })
    end
    resize()

    local function close()
        api.nvim_win_close(winid, true)
    end

    local selected_index --- @type integer?
    local augroup = api.nvim_create_augroup('bones.ui.select-' .. winid, { clear = true })

    api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(winid),
        group = augroup,
        callback = function()
            pcall(api.nvim_del_augroup_by_id, augroup)
            pcall(api.nvim_buf_delete, bufnr, { force = true })
            if selected_index then
                on_choice(items[selected_index], selected_index)
            else
                on_choice(nil, nil)
            end
        end,
    })

    -- Detect if the select float changed buffer (e.g. when pressing <C-o>)
    api.nvim_create_autocmd('BufEnter', {
        nested = true, -- `WinClosed` is not executed otherwise
        group = augroup,
        callback = function()
            if api.nvim_win_get_buf(winid) ~= bufnr then
                close()
            end
        end,
    })

    api.nvim_create_autocmd('VimResized', {
        group = augroup,
        callback = function()
            vim.schedule(resize)
        end,
    })

    vim.keymap.set('n', 'q', close, { buffer = bufnr, nowait = true })
    vim.keymap.set('n', '<Enter>', function()
        local row_index = api.nvim_win_get_cursor(winid)[1]
        if row_index <= #items then
            selected_index = row_index
            close()
        end
    end, { buffer = bufnr, nowait = true })

    api.nvim_set_current_win(winid)
    vim.cmd.stopinsert()
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
