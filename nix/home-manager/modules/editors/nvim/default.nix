{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.editors.nvim;
in
{
  options.local.editors.nvim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    dotfilesPath = mkOption {
      type = types.path;
      default = (import ../../data).dotfilesPath;
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins;
        let
          kommentary = pkgs.vimUtils.buildVimPlugin {
            pname = "kommentary";
            version = "2021-10-13";
            src = pkgs.fetchFromGitHub {
              owner = "b3nj5m1n";
              repo = "kommentary";
              rev = "12ecde4ed3ecb39964000a5fd034ae4c1d307388";
              sha256 = "6YNKYMxaKi02TLa+ebt97XGREnmTjdJAA3bSHFC4yX0=";
            };
          };
          nvim-rg = pkgs.vimUtils.buildVimPlugin {
            pname = "nvim-rg";
            version = "2021-05-21";
            src = pkgs.fetchFromGitHub {
              owner = "duane9";
              repo = "nvim-rg";
              rev = "cd8c70e4456ff6ee6f72fa4aaf428db10e91a139";
              sha256 = "sha256-RMjfjjx1DRrxG52VMh05csJgMiBm//Q5vzxro4IQ/Z4=";
            };
          };
          vim-koka = with pkgs; vimUtils.buildVimPlugin {
            pname = "vim-koka";
            version = "2018-09-17";
            src = fetchFromGitHub {
              owner = "Nymphium";
              repo = "vim-koka";
              rev = "a7a61e7eae12e5a60463a32e0b8fbd92f9c41fb7";
              sha256 = "sha256-8IPyOvzr6NbXT5hl6tNnJi4CNY094ivSAj+DYOBNt2g=";
            };
          };
          nvim-oh-lucy-theme = with pkgs; vimUtils.buildVimPlugin {
            pname = "oh-lucy.nvim";
            version = "2023-01-07";
            src = fetchFromGitHub {
              owner = "Yazeed1s";
              repo = "oh-lucy.nvim";
              rev = "706c74fe8dcc2014dc17bbc861a05d27623e06e3";
              sha256 = "sha256-DY40tabglFYGXB2NwCpTM5QHUt+uoO8Ti6XBfN3ocAU=";
            };
          };
        in [
          nvim-treesitter.withAllGrammars
          blink-cmp
          agda-vim
          comment-nvim
          diffview-nvim
          haskell-vim
          lean-nvim
          lualine-nvim
          luasnip
          neogit
          nvim-autopairs
          # nvim-cmp
          nvim-lightbulb
          nvim-lspconfig
          nvim-rg
          nvim-web-devicons
          plenary-nvim
          popup-nvim
          telescope-file-browser-nvim
          telescope-nvim
          trouble-nvim
          vim-choosewin
          vim-gitgutter
          vim-koka
          vim-lion
          vim-nix
          vim-python-pep8-indent
          vim-sneak
          vim-surround
          vim-vsnip
          vim-vsnip-integ

          # Colour schemes
          nightfox-nvim
          nvim-oh-lucy-theme
          oceanic-next
          oxocarbon-nvim
        ];

        extraLuaConfig = ''
            -- Options
            require("options")

            -- Package config
            require("packages.config")

            -- Theme
            require("theme")

            -- Keybindings
            require("keybindings")

            -- LSP
            require("lsp")

            -- Completion
            require("blink")

            -- Treesitter
            require("treesitter-config")

            -- Whitespace
            require("whitespace")
        '';

      # extraConfig = ''
      #   lua << EOF

      #   -- Options
      #   require("options")

      #   -- Package config
      #   require("packages.config")

      #   -- Theme
      #   require("theme")

      #   -- Keybindings
      #   require("keybindings")

      #   -- LSP
      #   require("lsp")

      #   -- Treesitter
      #   require("treesitter-config")

      #   -- Debugging
      #   require("debugging")

      #   -- Whitespace
      #   require("whitespace")

      #   -- Terminal
      #   require("terminal")

      #   EOF
      # '';
    };

    # Raw configuration files
    # nvim
    home.file.".config/nvim/lua".source = builtins.toPath "${cfg.dotfilesPath}/nvim/lua";
  };
}
