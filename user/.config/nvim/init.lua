require 'bones'

-- This global variables help achieve a faster startup when opening python files
-- More info:
--   - :help g:loaded_python3_provider
--   - https://github.com/neovim/neovim/issues/2437#issuecomment-522236703

vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
-- vim.g.python_host_prog = '/usr/bin/python'
-- vim.g.python3_host_prog = '/usr/bin/python3'
