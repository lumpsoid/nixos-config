{
  pkgs,
  lib,
  config,
  ...
}: 
let 
  cfg = config.module.windowManager.awesome;
in
{
  imports = [
    ../../windowSystem/x11.nix
  ];

  options = {
    module.windowManager.awesome = {
      enable =
        lib.mkEnableOption "enable my awesome config";
    };
  };

  config = lib.mkIf cfg.enable {
    module.windowSystem.x11.enable = true;

    services.xserver.windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        vicious
      ];
    };

    home-manager.users."qq" = {
      xdg.configFile."awesome/rc.lua".source = ./rc.lua;
    };
  };
}
