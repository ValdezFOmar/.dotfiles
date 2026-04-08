vim.wo[0][0].scrolloff = 999
vim.wo[0][0].cursorline = false
vim.wo[0][0].virtualedit = 'all'

vim.keymap.set('n', 'gd', '<C-]>', { buf = 0, desc = 'Jump to definition' })
