{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.profile.wayland.packages;
in {
  options = {
    profile.wayland.packages.enable =
      lib.mkEnableOption "enable my custom wayland config";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      libnotify
      waylock # session lock 
      fuzzel
    ];
  };
}
