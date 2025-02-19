{
  lib,
  config,
  ...
}: let
  cfg = config.universe.wayland.variables;
in {
  options = {
    universe.wayland.variables.enable =
      lib.mkEnableOption "enable wayland session variables";
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      WLR_NO_HARDWARE_CURSORS = 1;
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };
}
