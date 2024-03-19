{ lib, config, pkgs, ... }:
{
  options = {
    zsh-omen.enable = lib.mkEnableOption "enable zsh config";
  };

  config = lib.mkIf config.zsh-omen.enable {
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        "lll" = "ls -l";
        rebuild = "sudo nixos-rebuild switch --flake ~/Documents/nixos/#default";
      };
      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";
      initExtra = ''
        if [ -n "${commands[fzf-share]}" ]; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
        fi
      '';
    };
  };
}