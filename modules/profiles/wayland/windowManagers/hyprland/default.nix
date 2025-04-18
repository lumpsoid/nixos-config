{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.profile.windowManager.hyprland;

  browserExe = lib.getExe cfg.browser;
  terminalExe = lib.getExe cfg.terminal;

  printscreen = pkgs.callPackage ../../scripts/printscreen.nix {
    useWayland = true;
  };
in {
  options = {
    profile.windowManager.hyprland = {
      enable =
        lib.mkEnableOption "enable my custom config for hyperland";

      browser = lib.mkPackageOption pkgs "ungoogled-chromium" {};
      terminal = lib.mkPackageOption pkgs "foot" {};
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };

    home.sessionVariables = {
      #If your cursor becomes invisible
      #WLR_NO_HARDWARE_CURSORS = "1";
      #Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      WLR_NO_HARDWARE_CURSORS = 1;
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    home.packages = with pkgs; [
      libnotify
      mako # notification daemon
      #eww
      swww # wallpapers
      wl-clipboard
      # not exist
      #qt6-wayland
      #qt5-wayland
      rofi-wayland # bemenu
      # screenshot
      grim
      slurp
      imv # image viewer for wayland

      wlprop # to get window class
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        exec-once =
          [
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            #"${pkgs.swww}/bin/swww-daemon" # wallpaper
            #"${pkgs.swww}/bin/swww img /home/qq/Pictures/wallpaper/sad-loli.jpg"
            "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent"
            "${pkgs.openssh}/bin/ssh-add /home/qq/.ssh/id_ssh_git"
            "${pkgs.waybar}/bin/waybar"
            "${pkgs.mako}/bin/mako"
          ]
          ++ lib.lists.optional
          (cfg.terminal.pname
            == "foot")
          "${terminalExe} --server";

        env = "HYPRCURSOR_THEME,rose-pine-hyprcursor";

        monitor = ", highres, auto, 1.0";
        # trigger when the switch is turning off
        bindl = [
          ", switch:off:Lid Switch,exec,hyprctl keyword monitor eDP-1, 1920x1080, 0x0, 1"
          # trigger when the switch is turning on
          ", switch:on:Lid Switch,exec,hyprctl keyword monitor eDP-1, disable"
        ];

        # unscale XWayland
        xwayland = {
          force_zero_scaling = true;
        };

        general = {
          layout = "master";
        };

        master = {
          new_status = "master";
          #new_on_top = true;
        };

        misc = {
          enable_swallow = true;
          # The window class regex
          swallow_regex = cfg.terminal.pname;

          font_family = "0xProto Nerd Font";
        };

        "$mod" = "SUPER";

        input = {
          kb_layout = "us,ru";
          kb_variant = ",typewriter";
          kb_options = "grp:caps_toggle";
          repeat_rate = 30;
          repeat_delay = 300;
          follow_mouse = 1;
        };

        bindm = [
          "ALT, mouse:272, movewindow"
          "ALT, mouse:273, resizewindow"
        ];

        bind = [
          "$mod, Q, killactive"
          "$mod, D, exec, rofi -show drun -show-icons"
          "$mod, W, exec, ${browserExe}"
          "$mod, Return, exec, ${terminalExe}"
          "$mod, Space, layoutmsg, swapwithmaster master"
          "$mod CTRL, Space, togglefloating"
          "$mod, F, fullscreen"

          # Move focus with vim like
          "$mod, l, movefocus, l"
          "$mod, h, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # move window
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, l, movewindow, r"
          "$mod SHIFT, k, movewindow, u  "
          "$mod SHIFT, j, movewindow, d"

          # resize
          "$mod CTRL, h, resizeactive, -20 0"
          "$mod CTRL, l, resizeactive, 20 0"
          "$mod CTRL, k, resizeactive, 0 -20"
          "$mod CTRL, j, resizeactive, 0 20"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"

          # Audio
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

          # Brightness
          ", XF86MonBrightnessUp, exec, light -A 5"
          ", XF86MonBrightnessDown, exec, light -U 5"
          ", Print, exec, ${printscreen}/bin/printscreen"
        ];
      };
    };
  };
}
