local km = vim.api.nvim_set_keymap

-- General
--

-- Leader key
vim.g.mapleader = " "

-- Toggle search highlighting
km("n", "<Leader><Space>", ":set hlsearch!<CR>", {noremap = true, silent = true})

-- Window management
km("n", "<Leader>w", "<C-w>", {noremap = true, silent = true})

-- Plugin-specific
--

-- Kommentary
require("kommentary.config").use_extended_mappings()

-- Telescope
km("n", "<Leader>ff", [[<Cmd>lua require("telescope.builtin").find_files()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>.", [[<Cmd>lua require("telescope.builtin").find_files()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fg", [[<Cmd>lua require("telescope.builtin").live_grep()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fb", [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>,", [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fh", [[<Cmd>lua require("telescope.builtin").help_tags()<CR>]], {noremap = true, silent = true})

-- Compe
km("i", "<C-Space>", "compe#complete()", { noremap = true, silent = true, expr = true })
km("i", "<CR>", "compe#confirm(luaeval(\"require 'nvim-autopairs'.autopairs_cr()\"))", { noremap = true, silent = true, expr = true })
km("i", "<C-e>", "compe#close('<C-e>')", { noremap = true, silent = true, expr = true })
km("i", "<C-f>", "compe#scroll({ 'delta': +4 })", { noremap = true, silent = true, expr = true })
km("i", "<C-d>", "compe#scroll({ 'delta': -4 })", { noremap = true, silent = true, expr = true })

