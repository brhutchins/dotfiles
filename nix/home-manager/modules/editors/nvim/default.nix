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
          vim-koka = with pkgs; vimUtils.buildVimPluginFrom2Nix {
            pname = "vim-koka";
            version = "2018-09-17";
            src = fetchFromGitHub {
              owner = "Nymphium";
              repo = "vim-koka";
              rev = "a7a61e7eae12e5a60463a32e0b8fbd92f9c41fb7";
              sha256 = "sha256-8IPyOvzr6NbXT5hl6tNnJi4CNY094ivSAj+DYOBNt2g=";
            };
          };
          nvim-oh-lucy-theme = with pkgs; vimUtils.buildVimPluginFrom2Nix {
            pname = "oh-lucy.nvim";
            version = "2022-11-04";
            src = fetchFromGitHub {
              owner = "Yazeed1s";
              repo = "oh-lucy.nvim";
              rev = "b0fbfaf966ce0e61945cd783cfbec3a4a5808f20";
              sha256 = "sha256-qMxw6QyFf+HN/ul4+GTTOYghAlMf0GKbUF0rXKy4R04=";
            };
          };
          oxocarbon-nvim = with pkgs; vimUtils.buildVimPluginFrom2Nix {
            pname = "oxocarbon.nvim";
            version = "2022-12-10";
            src = fetchFromGitHub {
              owner = "nyoom-engineering";
              repo = "oxocarbon.nvim";
              rev = "749562ce8ffbcc5c4f69ec0dab4f4cdd0a8d2e47";
              sha256 = "sha256-gttooz2DXTOiFJswldMWaR+Kzeeeqt4+m4YzS1oI11I=";
            };
          };
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
          plenary-nvim
          popup-nvim
          purescript-vim
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
          oxocarbon-nvim
          nvim-oh-lucy-theme
          oceanic-next
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
