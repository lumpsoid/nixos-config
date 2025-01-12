{pkgs, ...}: {
  imports = [
    ../../modules/scripts/rebuild.nix
    ../../modules/scripts/devshellnix/devshellnix.nix
    ../../modules/profiles/wayland/windowManagers/niri
    ../../modules/profiles/wayland/terminals/foot
    ../../modules/profiles/wayland/status_bars/waybar
    ../../modules/profiles/wayland/notifications/mako
    ../../modules/profiles/wayland/packages
  ]; # Home Manager needs a bit of information about you and the paths it should
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
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    #badwolf
    bat
    meld # gui diff tool
    ungoogled-chromium
    broot
    joshuto # rust file manager
    localsend
    unison # ocaml sync tool
    kdePackages.okular # documents viewer
    zoom-us

    jql # rust jq
    monolith # rust bundle html into a single file
    pastel # rust to manipulate colors
    pipr # interactive pipe lines
    fd # rust find alternative

    discord
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

  # ~/.config
  #xdg.configFile = {
  #};

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
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
    # EDITOR = "emacs";
  };

  programs = {
    git = {
      enable = true;
      userEmail = "79290581+lumpsoid@users.noreply.github.com";
      userName = "lumpsoid";
    };
  };

  profile.wayland = {
    packages.enable = true;
    windowManager.niri.enable = true;
    status-bar.waybar.enable = true;
    terminal.foot.enable = true;
    notification.mako.enable = true;
  };

  scripts = {
    rebuild-nix.enable = false; # custom
    devshellnix.enable = true; # custom
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
