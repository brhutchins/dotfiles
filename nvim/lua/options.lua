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
vim.opt.mouse         = "a"

vim.o.completeopt = "menuone,noselect"

-- Highlight on yank
vim.cmd "au TextYankPost * lua vim.highlight.on_yank {on_visual = false}"

-- GUI font
--- Currently kind of hacky, because we need Hasklug for the devicons, but
--- Hasklig in the AUR seems to /be/ Hasklug, whereas Hasklig available in
--- homebrew is not. Coincidentally, my Mac is hdpi whereas my Linux box
--- currently is not. So we can fix the font sizes this way too.
vim.opt.guifont = "Hasklug Nerd Font:h12,Hasklig:h10"
