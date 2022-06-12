{ config, lib, pkgs, ... }:

with lib;
with pkgs;

let
  cfg = config.local.core;
  data = import ../data;
  isLinux = lib.strings.hasSuffix "linux" builtins.currentSystem;
  isDarwin = lib.strings.hasSuffix "darwin" builtins.currentSystem;
  gui-packages = {
    firefox = if isLinux then firefox-wayland else firefox;
    kitty = ../terminals/kitty;
  };
  mosh-git = mosh.overrideAttrs (super: {
    version = "git";
    src = fetchFromGitHub {
      owner = "mobile-shell";
      repo = "mosh";
      rev = "2f90add";
      sha256 = "sha256-0Ofdzym7CFiU6uG5yiSF+lIDBYYOiIVu+5tyIYHS6kk=";
    };
    patches = [];
    postPatch = ''
      substituteInPlace scripts/mosh.pl \
      --subst-var-by ssh "${openssh}/bin/ssh" \
      --subst-var-by mosh-client "$out/bin/mosh-client"
    '';
    configureFlags = [];
  });
  p = {
    utils = [
      bat
      fd
      fzf
      git
      gnupg
      htop
      httpie
      ispell
      jq
      mosh-git
      neofetch
      pandoc
      pomerium-cli
      procps
      pure-prompt
      rclone
      ripgrep
      slides
      tldr
      tmux
      unzip
      zenith
      zoxide
    ];
    languageServers = [
      rnix-lsp
    ];
    nixSpecific = [
      nix-prefetch-scripts
    ];
    fonts = [
      (nerdfonts.override { fonts = [ "Hasklig" "IBMPlexMono"]; })
      inter
      emacs-all-the-icons-fonts
    ];
    gui = with gui-packages; [
    ];
  };
  mkGui = lists.optionals cfg.gui.enable;
in
{
  imports = [
    ../darwin/core
    ../editors/doom
    ../editors/helix
    ../editors/nvim
    ../terminals/kitty
    ../linux/gui
  ];

  options.local.core = {
    gui.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether we're installing core gui apps (e.g., Firefox)";
    };

    work.enable = mkOption {
      type = types.bool;
      default = false;
      description = "If this is a work setup, we'll, e.g., use work email for Git.";
    };
  };

  config = {

    # nixpkgs.allowUnfree = true;

    home.packages =
         p.utils
      ++ p.languageServers
      ++ p.nixSpecific
      ++ mkGui p.fonts
      ++ mkGui p.gui;


    #####
    #
    # Nix

    programs.nix-index.enable = true;


    #####
    #
    # zsh

    programs.zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
      };

      initExtra = ''
    #   # Set prompt
    #   if test "$TERM" != "linux"
    #   then
    #     autoload -U promptinit && promptinit && prompt pure
    #   fi

      # zoxide
      eval "$(zoxide init zsh)"
      '';
    };

    programs.zsh.oh-my-zsh = {
      enable = true;
      plugins = [
        "vi-mode"
      ];
    };


    #####
    #
    # prompt

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };


    #####
    #
    # Environments

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };


    #####
    #
    # CLI utilities

    programs.exa = {
      enable = true;
      enableAliases = true;
    };

    programs.nnn = {
      enable = true;
      package = pkgs.nnn.override ({ withNerdIcons = true; });
      bookmarks = {
        h = "~";
        d = "~/Development";
      };
    };


    #####
    #
    # Version control

    programs.git = {
      enable = true;
      userName = "brhutchins";
      userEmail = data.email.personal;
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    programs.gh = {
      enable = true;
      settings.gitProtocol = "ssh";
    };


    #####
    #
    # Editors
    local.editors = {
      nvim.enable = true;
      helix.enable = true;
    };

    local.editors.doom.enable = true;


    #####
    #
    # Fonts

    fonts.fontconfig.enable = mkIf cfg.gui.enable true;


    #####
    #
    # GUI

    programs.firefox = mkIf isLinux {
      enable = true;
      package = mkIf isLinux (
        wrapFirefox firefox-unwrapped {
          forceWayland = true;
        }
      );
    };

    local.terminals.kitty.enable = mkIf cfg.gui.enable true;


    #####
    #
    # Darwin
    local.darwin.core.enable = stdenv.isDarwin;

  };
}
