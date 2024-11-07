{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    scripts.devshellnix.enable =
      lib.mkEnableOption "enable bulding 'devshellnix' script";
  };

  config = lib.mkIf config.scripts.devshellnix.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "devshellnix" (builtins.readFile ./devshellnix.sh))
    ];
  };
}
