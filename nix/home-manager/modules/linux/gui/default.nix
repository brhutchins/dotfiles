{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.linux.gui;
in
{

  imports = [
    ../core
  ];

  options.local.linux.gui = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # If we want linux gui, we want the linux core stuff too
    local.linux.core.enable = true;

    home.packages = with pkgs; [
      bitwarden
      firefox-wayland
      hicolor-icon-theme
      libappindicator-gtk3
      libnotify
      papirus-icon-theme
      pavucontrol
      playerctl
      wl-clipboard
      (google-chrome-beta.override {
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
          "--force-dark-mode"
        ];
      })

      ## Screen sharing
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk

      # Communication
      zoom-us
      teams
      obs-studio

      # Fonts
      hasklig
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
    ];

    gtk = mkIf cfg.enable {
      enable = true;
      font.package = pkgs.inter;
      font.name = "Inter Medium";
      font.size = 9;
      theme.name = "Adwaita:dark";
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    services.gammastep = {
      enable = true;
      provider = "geoclue2";
    };

    services.mako = {
      enable = true;
      backgroundColor = "#161916EE";
      borderSize = 0;
      borderRadius = 4;
      font = "Inter Light 10";
      progressColor = "source #5fb3b3FF";
      textColor = "#ddddddFF";
      iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/";
      padding = "8";
      width = 280;
      extraConfig = ''
        [urgency=low]
        background-color=#161916DD
        text-color=#aaaaaaEE
      '';
    };

    xdg = {
      enable = true;
      mime.enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          # Web
          "x-scheme-handler/http"         = ["firefox.desktop"];
          "x-scheme-handler/https"        = ["firefox.desktop"];
          "x-scheme-handler/about"        = ["firefox.desktop"];
          "x-scheme-handler/unknown"      = ["firefox.desktop"];
          "text/html"                     = ["firefox.desktop"];
          "application/x-extension-htm"   = ["firefox.desktop"];
          "application/x-extension-html"  = ["firefox.desktop"];
          "application/x-extension-shtml" = ["firefox.desktop"];
          "application/xhtml+xml"         = ["firefox.desktop"];
          "application/x-extension-xhtml" = ["firefox.desktop"];
          "application/x-extension-xht"   = ["firefox.desktop"];
        };
      };
    };


  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    GTK_THEME = "Adwaita:dark";
  };
  };

}
