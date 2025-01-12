{
  lib,
  config,
  ...
}: let
  cfg = config.profile.wayland.terminal.foot;
in {
  options = {
    profile.wayland.terminal.foot = {
      enable =
        lib.mkEnableOption "enable my custom foot module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";

          font = "0xProto Nerd Font:size=11";
          dpi-aware = "yes";
        };
      };
    };
  };
}
