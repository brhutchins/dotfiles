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
              rev = "12ecde4ed3ecb39964000a5fd034ae4c1d307388";
              sha256 = "6YNKYMxaKi02TLa+ebt97XGREnmTjdJAA3bSHFC4yX0=";
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
            version = "2022-03-27";
            src = pkgs.fetchFromGitHub {
              owner = "nvim-lualine";
              repo = "lualine.nvim";
              rev = "f14175e142825c69c5b39e8f1564b9945a97d4aa";
              sha256 = "sha256-DL/m1ef6XO7TbrPta13R2DuPKNbFozagLa2b1SNCznQ=";
            };
          };
          nvim-rg = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "nvim-rg";
            version = "2021-05-21";
            src = pkgs.fetchFromGitHub {
              owner = "duane9";
              repo = "nvim-rg";
              rev = "cd8c70e4456ff6ee6f72fa4aaf428db10e91a139";
              sha256 = "sha256-RMjfjjx1DRrxG52VMh05csJgMiBm//Q5vzxro4IQ/Z4=";
            };
          };
          kmonad-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "kmonad-vim";
            version = "2021-05-17";
            src = pkgs.fetchFromGitHub {
              owner = "kmonad";
              repo = "kmonad-vim";
              rev = "e09bea67ea18feb4f5d12173e70ce556128012bc";
              sha256 = "sha256-nW3sOXjTvlm7H73V9MEB8HJG3/lgMPHEDIP8ygJozE4";
            };
          };
          nvim-treesitter-latest = (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
            .overrideAttrs (old: {
                version = "2022-08-31";
                src = pkgs.fetchFromGitHub {
                    owner = "nvim-treesitter";
                    repo = "nvim-treesitter";
                    rev = "501db1459a7a46cb0766b3c56e9a6904bbcbcc97";
                    sha256 = "sha256-MGtvAtZ4VgZczalMlbftdTtPr6Ofxdkudpo6PmaVhtQ=";
                };
            });
        in [
          agda-vim
          diffview-nvim
          haskell-vim
          idris2-vim
          kommentary
          lean-nvim
          lualine
          neogit
          nvim-autopairs
          nvim-compe
          nvim-dap
          nvim-lightbulb
          nvim-lspconfig
          nvim-rg
          nvim-treesitter-latest
          # nvim-ts-autotag
          nvim-web-devicons
          oceanic-next
          plenary-nvim
          popup-nvim
          purescript-vim
          telescope-file-browser-nvim
          telescope-nvim
          trouble-nvim
          vim-choosewin
          vim-gitgutter
          vim-lion
          vim-nix
          vim-python-pep8-indent
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

        -- Debugging
        require("debugging")

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
