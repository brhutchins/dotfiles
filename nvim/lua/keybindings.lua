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
km("n", "<Leader>.", [[<Cmd>lua require("telescope.builtin").file_browser()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fg", [[<Cmd>lua require("telescope.builtin").live_grep()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fb", [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>,", [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fh", [[<Cmd>lua require("telescope.builtin").help_tags()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>/", [[<Cmd>lua require("telescope.builtin").git_files()<CR>]], {noremap = true, silent = true})

-- Compe
km("i", "<C-Space>", "compe#complete()", { noremap = true, silent = true, expr = true })
km("i", "<CR>", "compe#confirm(luaeval(\"require 'nvim-autopairs'.autopairs_cr()\"))", { noremap = true, silent = true, expr = true })
km("i", "<C-e>", "compe#close('<C-e>')", { noremap = true, silent = true, expr = true })
km("i", "<C-f>", "compe#scroll({ 'delta': +4 })", { noremap = true, silent = true, expr = true })
km("i", "<C-d>", "compe#scroll({ 'delta': -4 })", { noremap = true, silent = true, expr = true })

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
