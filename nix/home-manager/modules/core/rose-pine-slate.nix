{ lib, ... }:

with lib;

let
  colors = {
    base = "#16181d";
    surface = "#1f222a";
    overlay = "#2a2f3a";
    text = "#e0def4";
    muted = "#6e6a86";
    subtle = "#908caa";
    iris = "#c4a7e7";
    pine = "#31748f";
    foam = "#9ccfd8";
    rose = "#ebbcba";
    gold = "#f6c177";
    love = "#eb6f92";
  };
in
{
  options.local.theme."rose-pine-slate" = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the shared rose-pine-slate palette.";
    };

    colors = mkOption {
      type = types.attrsOf types.str;
      default = colors;
      readOnly = true;
      description = "Shared color palette values for rose-pine-slate.";
    };
  };
}
