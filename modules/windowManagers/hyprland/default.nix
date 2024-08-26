{
  pkgs,
  lib,
  config,
  ...
}: 
let 
  cfg = config.module.windowManager.hyprland;
in
{
  imports = [
    ../../status_bars/waybar/default.nix
    ../../terminals/foot/default.nix
  ];

  options = {
    module.windowManager.hyprland = { 
      enable =
        lib.mkEnableOption "enable my custom config for hyperland";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.sessionVariables = {
      #If your cursor becomes invisible
      #WLR_NO_HARDWARE_CURSORS = "1";
      #Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };

    hardware = {
      #Opengl
      opengl.enable = true;

      #Most wayland compositors need this
      nvidia.modesetting.enable = true;
    };

    module = {
      status-bar.waybar.enable = true;
      terminal.foot.enable = true;
    };

    home-manager.users."qq" = {
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
        foot # terminal
        # screenshot
        grim
        slurp

        wlprop # to get window class
      ];


      wayland.windowManager.hyprland =
        let
          browser = "firefox";
          # how to get path here
          terminal = "foot";
        in 
        {
        enable = true;
        settings = {
          exec-once = [
            "${pkgs.mako}/bin/mako"
            "${pkgs.swww}/bin/swww-daemon"
            "${pkgs.swww}/bin/swww img /home/qq/Pictures/wallpaper/sad-loli.jpg"
            "${pkgs.waybar}/bin/waybar"
            "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent"
            "${pkgs.foot}/bin/foot --server"
          ];

          monitor = ", highres, auto, 1.0";

          # unscale XWayland
          xwayland = {
            force_zero_scaling = true;
          };

          misc = {
            enable_swallow = true;
            # The window class regex
            swallow_regex = "foot";

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
            "$mod, W, exec, ${browser}"
            "$mod, Return, exec, ${terminal}"
            "$mod, Space, swapwindow, l"
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
          ];
        };
      };
    };
  };
}
