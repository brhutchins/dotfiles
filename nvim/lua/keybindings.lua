local km = vim.api.nvim_set_keymap

-- General
--

-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "  "

-- Toggle search highlighting
km("n", "<Leader><Space>", ":set hlsearch!<CR>", {noremap = true, silent = true})

-- Window management
km("n", "<Leader>w", "<C-w>", {noremap = true, silent = true})

-- Tab management
km("n", "<Leader><Tab>c", ":tabclose<CR>", {noremap = true, silent = true})
km("n", "<Leader><Tab>n", ":tabnew<CR>", {noremap = true, silent = true})

-- Plugin-specific
--

-- Telescope
km("n", "<Leader>ff", [[<Cmd>lua require("telescope.builtin").find_files()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>.", [[<Cmd>Telescope file_browser path=%:p:h<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fg", [[<Cmd>lua require("telescope.builtin").live_grep()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fb", [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>,", [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fh", [[<Cmd>lua require("telescope.builtin").help_tags()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>/", [[<Cmd>lua require("telescope.builtin").git_files()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>lr", [[<Cmd>lua require("telescope.builtin").lsp_references()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>ls", [[<Cmd>lua require("telescope.builtin").lsp_workspace_symbols()<CR>]], {noremap = true, silent = true})

-- Trouble
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)

-- Git
km("n", "<leader>gg", [[<Cmd> lua require("neogit").open() <CR>]],
   {noremap = true, silent = true}
)

-- Choose window
km("n", "<leader>wp", "<Plug>(choosewin)", {})
