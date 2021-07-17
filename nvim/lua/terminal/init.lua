-- Disable linue numbers and add some padding for terminal
vim.api.nvim_command([[
  augroup terminal
  autocmd TermOpen * setlocal foldcolumn=1 nonumber
  augroup END
]])
