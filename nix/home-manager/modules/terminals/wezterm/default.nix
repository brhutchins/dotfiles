{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.terminals.wezterm;
in
{
  options.local.terminals.wezterm = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
      return {
        font = wezterm.font_with_fallback { "Hasklig", "Symbols Nerd Font Mono" },
        font_size = 10.0,
        color_scheme = "Panda (Gogh)",
        hide_tab_bar_if_only_one_tab = true,
        native_macos_fullscreen_mode = true,
        window_decorations="RESIZE",
        window_padding = {
          left = "3cell",
          right = "3cell",
          top = "1cell",
          bottom = "1cell"
        },
      }
      '';

    };
  };
}
