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

