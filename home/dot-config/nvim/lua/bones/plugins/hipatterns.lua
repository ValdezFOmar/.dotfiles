---@param pattern string
local function hexcolor(pattern)
    return {
        pattern = pattern,
        group = function(_, match)
            return require('mini.hipatterns').compute_hex_color_group(match, 'fg')
        end,
        extmark_opts = function(_, _, data)
            return {
                priority = vim.hl.priorities.user,
                virt_text = { { ' ', data.hl_group } },
                virt_text_pos = 'inline',
                right_gravity = false,
            }
        end,
    }
end

---@type LazyPluginSpec
return {
    'nvim-mini/mini.hipatterns',
    init = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'Disable mini.hipatterns for servers that support document color',
            group = vim.api.nvim_create_augroup('bones.hipatterns', {}),
            callback = function(ev)
                local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
                if client:supports_method 'textDocument/documentColor' then
                    vim.b[ev.buf].minihipatterns_disable = true
                    require('mini.hipatterns').disable(ev.buf)
                end
            end,
        })
    end,
    opts = {
        highlighters = {
            hexcolor6 = hexcolor '#%x%x%x%x%x%x%f[%W]',
            hexcolor8 = hexcolor '()#%x%x%x%x%x%x()%x%x%f[%W]',
        },
    },
}
