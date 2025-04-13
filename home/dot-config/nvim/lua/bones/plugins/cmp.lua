local PLUGIN = { 'hrsh7th/nvim-cmp' }

PLUGIN.dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'L3MON4D3/LuaSnip',
}

---Jump between snippet placeholders
---@param direction -1|1
---@return function
local function luasnip_jump(direction)
    local luasnip = require 'luasnip'
    local cmp = require 'cmp'
    return cmp.mapping(function(fallback)
        if luasnip.locally_jumpable(direction) then
            luasnip.jump(direction)
        else
            fallback()
        end
    end, { 'i', 's' })
end

local function confirm_first_or_selected()
    local cmp = require 'cmp'
    return cmp.mapping(function(fallback)
        if not cmp.visible() then
            fallback()
            return
        end
        if not cmp.get_selected_entry() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        end
        cmp.confirm()
    end, { 'i', 's' })
end

function PLUGIN.config()
    local MAX_WIDTH = 28
    local FORWARD = 1
    local BACKWARD = -1
    local SCROLL_DOWN = 5
    local SCROLL_UP = -SCROLL_DOWN
    local CUTOFF_CHAR = '…'

    local cmp = require 'cmp'

    cmp.setup {
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'luasnip' },
            { name = 'lazydev', group_index = 0 },
        }, {
            { name = 'buffer' },
        }),
        formatting = {
            fields = { 'abbr', 'kind', 'menu' },
            expandable_indicator = true,
            format = function(entry, item)
                local name = entry.source.name
                if name == 'nvim_lsp' then
                    item.menu = '[LSP]'
                elseif name == 'nvim_lua' then
                    item.menu = '[neovim]'
                else
                    item.menu = '[' .. name .. ']'
                end
                if #item.abbr > MAX_WIDTH then
                    item.abbr = item.abbr:sub(1, MAX_WIDTH - #CUTOFF_CHAR) .. CUTOFF_CHAR
                end
                return item
            end,
        },
        mapping = cmp.mapping.preset.insert {
            ['<Tab>'] = confirm_first_or_selected(),
            ['<A-k>'] = cmp.mapping.select_prev_item(),
            ['<A-j>'] = cmp.mapping.select_next_item(),
            ['<C-k>'] = cmp.mapping.scroll_docs(SCROLL_UP),
            ['<C-j>'] = cmp.mapping.scroll_docs(SCROLL_DOWN),
            ['<C-Space>'] = cmp.mapping.complete(),
            -- Navigate between snippet placeholder
            ['<A-Tab>'] = luasnip_jump(FORWARD),
            ['<A-f>'] = luasnip_jump(FORWARD),
            ['<A-b>'] = luasnip_jump(BACKWARD),
        },
    }
end

return PLUGIN
