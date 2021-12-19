{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.terminals.kitty;
in
{
  options.local.terminals.kitty = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    dotfilesPath = mkOption {
      type = types.path;
      default = (import ../../data).dotfilesPath;
    };

    theme = mkOption {
      type = types.path;
      default = "${cfg.dotfilesPath}/kitty/themes/oceanic-next.conf";
      description = "Absolute path to theme file for Kitty.";
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font.name = "Hasklug Nerd Font";
      font.size = 11;

      keybindings = {
        "kitty_mod+equal" = "change_font_size all +1.0";
        "kitty_mod+minus" = "change_font_size all -1.0";
        "kitty_mod+backspace" = "change_font_size all 0.0";
      };

      settings = {
        mouse_hide_wait = "3.0";
        # Bell
        enable_audio_bell = "no";
        visual_bell_duration = "0.1";
        bell_on_tab = "yes";
        # Window layout
        window_border_width = "1.0px";
        draw_minimal_borders = "yes";
        window_margin_width = 0;
        window_padding_width = 10;
        active_border_color = "#d8dee9";
        inactive_border_color = "#555555";
        inactive_text_alpha = "0.9";
        hide_window_decorations = "no";
        confirm_os_window_close = 1;
        # OS-specific
        macos_titlebar_color = "background";
        macos_option_as_alt = "left";
        # Tab bar
        tab_bar_edge = "top";
        tab_bar_margin_width = "8.0";
        tab_bar_margin_height = "5.0 0.0";
        tab_bar_style = "separator";
        tab_separator = "\"   \"";
        tab_title_template = "\"{index}: {title[:21]}\"";
        tab_activity_symbol = "⋮";
        active_tab_font_style = "bold-italic";
        inactive_tab_font_style = "bold";

      };
      # Colour scheme
      ## Applied through file
      extraConfig = builtins.readFile cfg.theme;

      darwinLaunchOptions = mkIf pkgs.stdenv.isDarwin [
          "--single-instance"
          "--directory=/tmp/my-dir"
          "--listen-on=unix:/tmp/my-socket"
        ];
    };

    # Theme
    home.file.".config/kitty/theme.conf".source = cfg.theme;
  };
}
