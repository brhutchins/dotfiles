vim.opt.expandtab     = true
vim.opt.tabstop       = 2
vim.opt.shiftwidth    = 2
vim.opt.ignorecase    = true
vim.opt.smartcase     = true
vim.opt.number        = true
vim.opt.splitright    = true
vim.opt.termguicolors = true
vim.opt.list          = true
vim.opt.hidden        = true

vim.o.completeopt = "menuone,noselect"

-- Highlight on yank
vim.cmd "au TextYankPost * lua vim.highlight.on_yank {on_visual = false}"
