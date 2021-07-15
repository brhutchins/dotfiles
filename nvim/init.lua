-- Options
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.number = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.o.completeopt = "menuone,noselect"
-- opt.wildmode = {"list", "longest"}

-- Install plugins
vim.cmd "packadd paq-nvim"

require "paq" {
  "savq/paq-nvim"; -- Let Paq manage itself

  "neovim/nvim-lspconfig";
  "hrsh7th/nvim-compe";    -- Completion
  "nvim-treesitter/nvim-treesitter";
  "nvim-lua/popup.nvim";   -- Requirement for telescope
  "nvim-lua/plenary.nvim"; -- Requirement for telescope
  "nvim-telescope/telescope.nvim";
  "b3nj5m1n/kommentary";
  "tommcdo/vim-lion";      -- Alignment: vimscript plugin
  "windwp/nvim-autopairs";
  "hrsh7th/vim-vsnip";
  "hrsh7th/vim-vsnip-integ";
  "Shatur/neovim-ayu";
  "hoob3rt/lualine.nvim";
  {'kyazdani42/nvim-web-devicons', opt = true};
}

-- Theme
--
vim.cmd [[colorscheme ayu]]

-- Plugin config
--

-- Compe
require'compe'.setup {
  enabled          = true;
  autocomplete     = true;
  debug            = false;
  min_length       = 1;
  preselect        = "enable";
  throttle_time    = 80;
  source_timeout   = 200;
  resolve_timeout  = 800;
  incomplete_delay = 400;
  max_abbr_width   = 100;
  max_kind_width   = 100;
  max_menu_width   = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}

-- nvim-autopairs
require("nvim-autopairs").setup()

-- lualine.nvim
require('lualine').setup{
    options = {
            theme = "onedark",
            component_separators = "",
            section_separators = ""
    }
}


-- Keybindings

local km = vim.api.nvim_set_keymap

-- General
--

-- Leader key
vim.g.mapleader = " "

-- Toggle search highlighting
km("n", "<Leader><Space>", ":set hlsearch!<CR>", {noremap = true, silent = true})

-- Plugin-specific
--

-- Kommentary
require("kommentary.config").use_extended_mappings()

-- Telescope
km("n", "<Leader>ff", [[<Cmd>lua require("telescope.builtin").find_files()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fg", [[<Cmd>lua require("telescope.builtin").live_grep()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fb", [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], {noremap = true, silent = true})
km("n", "<Leader>fh", [[<Cmd>lua require("telescope.builtin").help_tags()<CR>]], {noremap = true, silent = true})

-- Compe
km("i", "<C-Space>", "compe#complete()", { noremap = true, silent = true, expr = true })
km("i", "<CR>", "compe#confirm(luaeval(\"require 'nvim-autopairs'.autopairs_cr()\"))", { noremap = true, silent = true, expr = true })
km("i", "<C-e>", "compe#close('<C-e>')", { noremap = true, silent = true, expr = true })
km("i", "<C-f>", "compe#scroll({ 'delta': +4 })", { noremap = true, silent = true, expr = true })
km("i", "<C-d>", "compe#scroll({ 'delta': -4 })", { noremap = true, silent = true, expr = true })

-- LSP
--
local lspconfig = require("lspconfig")

-- Snippets
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Python/Pyright
lspconfig.pyright.setup{}

-- HTML
lspconfig.html.setup{
  cmd = { "html-languageserver", "--stdio" },
  filetypes = { "html" },init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true
    }
  },
  settings = {}
}

-- Typescript
lspconfig.tsserver.setup{}
