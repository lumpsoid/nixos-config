{pkgs, lib, config, ... }: 
{
  options = {
    programs.awesome.myconfig = 
      lib.mkEnableOption "enable my custom config";
  };

  config = lib.mkIf config.programs.awesome.myconfig {
    xdg.configFile."awesome/rc.lua".source = ./rc.lua;
  };
}
