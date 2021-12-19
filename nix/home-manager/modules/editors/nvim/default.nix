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
          black-vim = pkgs.vimUtils.buildVimPlugin (rec {
            pname = "black.vim";
            version = "21.12b0";
            # sourceRoot = "./plugin";
            installPhase = ''
              runHook preInstall

              mkdir -p $out
              cp ./plugin/* $out
            '';
            src = pkgs.fetchFromGitHub {
              owner = "psf";
              repo = "black";
              rev = version;
              sha256 = "sha256-qYf666gonRgxUw+SFe1ILpGQpdL5sjXFTr0Pepk5iog=";
            };
          });
          kommentary = pkgs.vimUtils.buildVimPlugin {
            pname = "kommentary";
            version = "2021-10-13";
            src = pkgs.fetchFromGitHub {
              owner = "b3nj5m1n";
              repo = "kommentary";
              rev = "8f1cd74ad28de7d7c4fda5d8e8557ff240904b42";
              sha256 = "0avd7v0nzz31nf5vj29npw5g7c2rrlirvkyd042qlh5y2vas7b2g";
            };
          };
          nvim-ts-autotag = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "nvim-ts-autotag";
            version = "2021-10-09";
            src = pkgs.fetchFromGitHub {
              owner = "windwp";
              repo = "nvim-ts-autotag";
              rev = "80d427af7b898768c8d8538663d52dee133da86f";
              sha256 = "1hcwppfqyl423lxp8i01dvn7szcfds6apcxjfq84kbhs384hs8pi";
            };
          };
          lualine = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "lualine";
            version = "2021-12-09";
            src = pkgs.fetchFromGitHub {
              owner = "nvim-lualine";
              repo = "lualine.nvim";
              rev = "d68631d2c02bd31d937349d739c625cc81dd9ac1";
              sha256 = "sha256-5DYBCXS+DLsoK5yNlcGVcKUYd/gbAOYuLIQbUVd2YGw=";
            };
          };
        in [
          black-vim
          haskell-vim
          # indent-blankline-nvim
          kommentary
          lualine
          nvim-autopairs
          nvim-compe
          nvim-lightbulb
          nvim-lspconfig
          nvim-treesitter
          nvim-ts-autotag
          nvim-web-devicons
          oceanic-next
          plenary-nvim
          popup-nvim
          purescript-vim
          vim-python-pep8-indent
          telescope-nvim
          trouble-nvim
          vim-gitgutter
          vim-lion
          vim-nix
          vim-sneak
          vim-surround
          vim-vsnip
          vim-vsnip-integ
        ];

      extraConfig = ''
        lua << EOF

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

        -- Treesitter
        require("treesitter-config")

        -- Whitespace
        require("whitespace")

        -- Terminal
        require("terminal")

        EOF
      '';
    };

    # Raw configuration files
    # nvim
    home.file.".config/nvim/lua".source = builtins.toPath "${cfg.dotfilesPath}/nvim/lua";
  };
}
