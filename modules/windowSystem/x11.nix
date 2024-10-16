{
  pkgs,
  lib,
  config,
  ...
}: 
let 
  cfg = config.module.windowSystem.x11;
in
{
  options = {
    module.windowSystem.x11 = {
      enable =
        lib.mkEnableOption "enable x11 config";
    };
  };

  config = lib.mkIf cfg.enable {

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      displayManager.sessionCommands = ''
        xset r rate 300 30
        ssh-add ~/.ssh/id_ssh_git
      '';
      # Enable touchpad support (enabled default in most desktopManager).
      #libinput.enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us,ru";
        variant = ",typewriter";
        options = "grp:caps_toggle";
      };
    };
  };
}

