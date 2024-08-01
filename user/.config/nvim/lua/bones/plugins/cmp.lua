local PLUGIN = { 'hrsh7th/nvim-cmp' }

PLUGIN.dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'L3MON4D3/LuaSnip',
}

local function luasnip_jump_forward()
    local luasnip = require 'luasnip'
    local cmp = require 'cmp'
    return cmp.mapping(function(fallback)
        if luasnip.jumpable(1) then
            luasnip.jump(1)
        else
            fallback()
        end
    end, { 'i', 's' })
end

local function luasnip_jump_backward()
    local luasnip = require 'luasnip'
    local cmp = require 'cmp'
    return cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { 'i', 's' })
end

local function confirm_selected_or_first_item()
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

local function previous_suggestion()
    local cmp = require 'cmp'
    return cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
        else
            fallback()
        end
    end, { 'i', 's' })
end

local function next_suggestion()
    local cmp = require 'cmp'
    return cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        else
            fallback()
        end
    end, { 'i', 's' })
end

function PLUGIN.config()
    local cmp = require 'cmp'
    local maxwidth = 28

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
                    item.menu = ('[%s]'):format(name)
                end
                if #item.abbr > maxwidth then
                    item.abbr = item.abbr:sub(1, maxwidth - 1) .. '…'
                end
                return item
            end,
        },
        mapping = cmp.mapping.preset.insert {
            ['<Tab>'] = confirm_selected_or_first_item(),
            ['<C-k>'] = previous_suggestion(),
            ['<C-j>'] = next_suggestion(),
            ['<C-Space>'] = cmp.mapping.complete(),
            -- Navigate between snippet placeholder
            ['<A-Tab>'] = luasnip_jump_forward(),
            ['<A-f>'] = luasnip_jump_forward(),
            ['<A-b>'] = luasnip_jump_backward(),
        },
    }
end

return PLUGIN
