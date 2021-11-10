vim.cmd "packadd paq-nvim"

require "paq" {
  "savq/paq-nvim"; -- Let Paq manage itself

  "neovim/nvim-lspconfig";
  "folke/trouble.nvim";
  "hrsh7th/nvim-compe";    -- Completion
  "kosayoda/nvim-lightbulb";
  "nvim-treesitter/nvim-treesitter";
  "windwp/nvim-ts-autotag";
  "nvim-lua/popup.nvim";   -- Requirement for telescope
  "nvim-lua/plenary.nvim"; -- Requirement for telescope
  "nvim-telescope/telescope.nvim";
  "b3nj5m1n/kommentary";
  "tommcdo/vim-lion";      -- Alignment: vimscript plugin
  "windwp/nvim-autopairs";
  "hrsh7th/vim-vsnip";
  "hrsh7th/vim-vsnip-integ";
  "hoob3rt/lualine.nvim";
  "kyazdani42/nvim-web-devicons";
  "justinmk/vim-sneak";
  "tpope/vim-surround";
  -- "blackCauldron7/surround.nvim";
  "airblade/vim-gitgutter";
  "neovimhaskell/haskell-vim";
  "LnL7/vim-nix";
  "Yggdroot/indentLine";

  -- Themes
  "Shatur/neovim-ayu";
  "glepnir/zephyr-nvim";
  "mhartington/oceanic-next"
}

