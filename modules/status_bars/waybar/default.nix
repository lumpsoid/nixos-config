{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.module.status-bar.waybar;
in
{
  options = {
    module.status-bar.waybar.enable =
      lib.mkEnableOption "enable my custom waybar config";
  };

  config = lib.mkIf cfg.enable {
    
    home-manager.users."qq" = {
      home.packages = with pkgs; [
        waybar
      ];

      xdg.configFile."waybar/config".source = ./config;
    };
  };
}

