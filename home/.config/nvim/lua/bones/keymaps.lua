local utils = require 'bones.utils'
local map = vim.keymap.set

map('n', '<S-Enter>', utils.trykey('O<Esc>0"_D', '<S-Enter>'), {
    expr = true,
    desc = 'Add new line above the cursor',
    noremap = true,
})
map('n', '<Enter>', utils.trykey('o<Esc>0"_D', '<Enter>'), {
    expr = true,
    desc = 'Add new line under the cursor',
    noremap = true,
})

map('n', 'gx', utils.uri.open, { desc = 'Open a URI' })
