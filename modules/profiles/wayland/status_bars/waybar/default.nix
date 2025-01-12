{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.profile.wayland.status-bar.waybar;
in {
  options = {
    profile.wayland.status-bar.waybar.enable =
      lib.mkEnableOption "enable my custom waybar config";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      waybar
    ];

    xdg.configFile."waybar/config".source = ./config;
    xdg.configFile."waybar/style.css".source = ./style.css;
    xdg.configFile."waybar/power_menu.xml".source = ./power_menu.xml;
  };
}
