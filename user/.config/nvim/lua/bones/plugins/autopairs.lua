local PLUGIN = { 'windwp/nvim-autopairs' }

PLUGIN.event = 'InsertEnter'

function PLUGIN.config()
    require('nvim-autopairs').setup {
        enable_check_bracket_line = false,
    }

    local cmp = require 'cmp'
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

    -- If you want to insert `(` after the selected function or method item
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { filetypes = { sh = false } })
end

return PLUGIN
