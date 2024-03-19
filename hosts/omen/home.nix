{ config, pkgs, lib, ... }:

let 
  nFunctionNnn = import ./modules/n-function.nix;
in
{
  #imports = [
  #];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "qq";
  home.homeDirectory = "/home/qq";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "nnn.desktop";
  };

  #wayland.windowManager.river = { 
  #  enable = true;
  #};
  xdg.configFile."river/init".source = ./dotfiles/river/init;
  xdg.configFile."waybar/config".source = ./dotfiles/waybar/config;
  xdg.configFile."waybar/style.css".source = ./dotfiles/waybar/style.css;
 #   settings = {
 #     declare-mode = [
 #       "normal"
 #     ];
 #     keyboard-layout = {
 #       "-options" = {
 #         "'grp:caps_toggle'" = "'us,ru(typewriter)'";
 #       };
 #     };
 #     map = {
 #       normal = {
 #         "Super Q" = "close";
 #         "Super+Shift Q" = "exit";
 #         "Super Return" = "spawn 'foot'";
 #         "Super W" = "spawn 'firefox'";
 #         "Super D" = "spawn 'rofi -show drun'";
 #         "Super J" = "focus-view next";
 #         "Super K" = "focus-view previous";
 #         "Super Space" = "zoom";
 #         "Super H" = "send-layout-cmd rivertile 'main-ration -0.05'";
 #         "Super L" = "send-layout-cmd rivertile 'main-ration +0.05'";
 #         "Super+Shift H" = "send-layout-cmd rivertile 'main-count +1'";
 #         "Super+Shift L" = "send-layout-cmd rivertile 'main-count -1'";
 #         "Super BTN_LEFT" = "move-view";
 #         "Super BTN_RIGHT" = "resize-view";
 #         "Super BTN_MIDDLE" = "toggle-float";
 #       };
 #     };
 #   };
 #   extraConfig = ''
 #   riverctl default-layout rivertile
 #   rivertile -view-padding 6 -outer-padding 6 &
 #   '';
 # };
  programs = {
    foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "Meslo LG M:size=15";
        };
      };
    };
    bash = {
      enable = true;
      enableCompletion = true;
      historyControl = [ "erasedups" ];
      initExtra = ''
      ${nFunctionNnn}
      export PATH="$PATH":"$HOME/.pub-cache/bin"
      '';
      shellAliases = {
        ll = "ls -l";
        rebuild = "sudo nixos-rebuild switch --flake ~/Documents/nixos/#default";
      };
    };
    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [
        "--preview 'tree -C {} | head -200'"
      ];
      historyWidgetOptions = [
        "--sort"
        "--exact"
      ];
    };
    vscode = {
      enable = true;
      #extensions = with pkgs.vscode-extensions; [
      #  vscodevim.vim
      #  dart-code.flutter
      #  dart-code.dart-code
      #];
    };
  };
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    tree
    fd
    xterm
    
    librewolf
    river
    rofi
    wl-clipboard
    obsidian
    sqlitebrowser
    waybar
    nnn
    nchat
    neovim
    discord
    
    libreoffice-qt
    hunspell
    hunspellDicts.ru_RU
    hunspellDicts.en_US
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/qq/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
