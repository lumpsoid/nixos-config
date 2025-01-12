{
  lib,
  config,
  ...
}: let
  cfg = config.profile.wayland.notification.mako;
in {
  options = {
    profile.wayland.notification.mako = {
      enable =
        lib.mkEnableOption "enable my custom mako module";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
    };
  };
}
