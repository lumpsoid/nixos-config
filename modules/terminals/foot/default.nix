{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.module.terminal.foot;
in {
  options = {
    module.terminal.foot.enable =
      lib.mkEnableOption "enable my custom foot module";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."qq" = {
      home.packages = with pkgs; [
        waybar
      ];

      xdg.configFile."foot/foot.ini".text = ''
        font=0xProtoNerdFontMono-Regular:size=16
      '';
    };
  };
}
