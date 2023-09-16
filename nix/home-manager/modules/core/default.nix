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
  zellij-head = zellij.overrideAttrs (old: rec {
    # version = "2022-07-16";
    # src = fetchFromGitHub {
    #   owner  = "zellij-org";
    #   repo = "zellij";
    #   rev = " b78ecdf";
    #   sha256 = "";
    # };
    # cargoDeps = old.cargoDeps.overrideAttrs (_: {
    #   inherit src;
    #   outputHash = "";
    # });
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
      rclone
      ripgrep
      slides
      tldr
      tmux
      unzip
      zoxide
    ];
    languages = [
      agda
    ];
    languageServers = [
      nil
    ];
    nixSpecific = [
      nix-prefetch-scripts
    ];
    fonts = [
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      hasklig
      ibm-plex
      inter
      emacs-all-the-icons-fonts
    ];
    gui = with gui-packages; [
    ];
  };
  mkGui = lists.optionals cfg.gui.enable;
  sessionVariablesForLinux = mkIf isLinux {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway"; 
  };
in
{
  imports = [
    ../darwin/core
    ../editors/doom
    ../editors/helix
    ../editors/nvim
    ../terminals/kitty
    ../terminals/wezterm
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
      ++ p.languages
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
      syntaxHighlighting.enable = true;
      shellAliases = {
        kill_bg = "kill $(jobs -l | sed -r 's/\[([0-9]+)\].+/%\1/')";
      };

      initExtra = ''
      # disable syntax highlighting on paste, to avoid speed issues
      zle_highlight+=(paste:none)

      # zoxide
      eval "$(zoxide init zsh)"

      ### Fix slowness of pastes with zsh-syntax-highlighting.zsh
      pasteinit() {
        OLD_SELF_INSERT=''${''${(s.:.)widgets[self-insert]}[2,3]}
        zle -N self-insert url-quote-magic
      }

      pastefinish() {
        zle -N self-insert $OLD_SELF_INSERT
      }
      zstyle :bracketed-paste-magic paste-init pasteinit
      zstyle :bracketed-paste-magic paste-finish pastefinish
      ### Fix slowness of pastes

      # functions
      gch () {
        if [[ -z $1 ]]; then
          SEARCH=("fzf")
        else
          SEARCH=("fzf" "--query" "$1")
        fi
        git checkout "$(git branch --all | {$SEARCH[@]} | tr -d ' ')"
      }
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
    # bash

    programs.bash = {
      enable = true;
      enableCompletion = true;
    };


    #####
    #
    # prompt

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };


    #####
    #
    # Environments

    home.sessionVariables = {
      EDITOR = "nvim";
    }
    // sessionVariablesForLinux;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };


    #####
    #
    # CLI utilities

    programs.eza = {
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

    programs.zellij = {
      enable = true;
      package = zellij-head;
      settings = {
        pane_frames = false;
        simplified_ui = true;
        theme = "nord";
        themes.nord = {
          fg = [216 222 233]; #D8DEE9
          bg = [46 52 64]; #2E3440
          black = [59 66 82]; #3B4252
          red = [191 97 106]; #BF616A
          green = [163 190 140]; #A3BE8C
          yellow = [235 203 139]; #EBCB8B
          blue = [129 161 193]; #81A1C1
          magenta = [180 142 173]; #B48EAD
          cyan = [136 192 208]; #88C0D0
          white = [229 233 240]; #E5E9F0
          orange = [208 135 112]; #D08770
          gray = [100 100 100];
        };
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
        core = {
          editor = "nvim";
        };
        # Sign all commits using ssh key
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = config.home.homeDirectory + "/.config/git/allowed_signers";
        user.signingkey = config.home.homeDirectory + "/.ssh/id_ed25519.pub";
      };
      diff-so-fancy = {
        enable = true;
      };
    };

    programs.gh = {
      enable = true;
      settings.gitProtocol = "ssh";
    };

    home.file.".config/git/allowed_signers".text =
      "${data.email.personal} ${builtins.readFile (config.home.homeDirectory + "/.ssh/id_ed25519.pub")}";


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

    programs.firefox = mkIf (cfg.gui.enable && isLinux) {
      enable = true;
    };

    local.terminals.kitty.enable = mkIf cfg.gui.enable true;
    local.terminals.wezterm.enable = mkIf cfg.gui.enable true;


    #####
    #
    # Darwin
    local.darwin.core.enable = stdenv.isDarwin;

  };
}


