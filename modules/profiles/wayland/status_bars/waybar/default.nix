{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.profile.wayland.status-bar.waybar;
  validWindowManagers = ["hyprland" "sway"];

  # Function to convert an attribute set to a formatted JSON string
  attrSetToFormattedString = attrSet: let
    jsonString = builtins.toJSON attrSet;
    trimmedJsonString = builtins.substring 1 (builtins.stringLength jsonString - 2) jsonString; # Remove outermost braces
  in
    trimmedJsonString;

  # Function to convert a list of attribute sets to a formatted string
  listOfAttrSetsToFormattedString = attrSets:
    builtins.concatStringsSep ", " (map attrSetToFormattedString attrSets);
in {
  options = {
    profile.wayland.status-bar.waybar = {
      enable =
        lib.mkEnableOption "enable my custom waybar config";

      windowManager = lib.mkOption {
        type = lib.types.enum validWindowManagers;
        description = "The window manager to use. Valid options are 'hyprland' or 'sway'.";
        default = "sway";
      };

      hyprlandModules = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        description = "List of attribute sets for hyprland modules.";
        default = [];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      waybar
    ];

    xdg.configFile."waybar/config".text = let
      # Conditionally add items to the list based on the chosen window manager
      modulesLeft = let
        # Define the base list
        baseModulesLeft = [];

        hyprlandModulesLeft = ["hyprland/workspaces" "hyprland/mode" "hyprland/scratchpad" "custom/media"];

        swayModulesLeft = ["sway/workspaces" "sway/mode"];
      in
        if cfg.windowManager == "hyprland"
        then hyprlandModulesLeft
        else if cfg.windowManager == "sway"
        then swayModulesLeft
        else baseModulesLeft;

      modulesCenter =
        if cfg.windowManager == "hyprland"
        then [
          "hyprland/window"
        ]
        else if cfg.windowManager == "sway"
        then [
          "sway/window"
        ]
        else [];

      hyprlandModules =
        [
          {
            "hyprland/workspaces" = {
              disable-scroll = true;
              all-outputs = false;
              warp-on-scroll = false;
              format = "{name} {icon}";
              format-icons = {
                urgent = "";
                focused = "";
                default = "";
              };
            };
          }
          {
            "hyprland/mode" = {
              "format" = "<span style=\"italic\">{}</span>";
            };
          }
          {
            "hyprland/scratchpad" = {
              "format" = "{icon} {count}";
              "show-empty" = false;
              "format-icons" = ["" ""];
              "tooltip" = true;
              "tooltip-format" = "{app}: {title}";
            };
          }
          {}
        ]
        ++ cfg.hyprlandModules;

      hyprlandModulesString =
        if cfg.windowManager == "hyprland"
        then listOfAttrSetsToFormattedString hyprlandModules
        else "";
    in
      /*
      jsonc
      */
      ''
        {
            // "layer": "top", // Waybar at top layer
            "position": "top", // Waybar position (top|bottom|left|right)
            //"height": 30, // Waybar height (to be removed for auto height)
            // "width": 1280, // Waybar width
            "spacing": 4, // Gaps between modules (4px)
            // Choose the order of the modules
            "modules-left": ${builtins.toJSON modulesLeft},
            "modules-center": ${builtins.toJSON modulesCenter},
            "modules-right": [
                "mpd",
                "idle_inhibitor",
                "pulseaudio",
                "network",
                "power-profiles-daemon",
                "cpu",
                "memory",
                "temperature",
                "backlight",
                "keyboard-state",
                "hyprland/language",
                "battery",
                "clock",
                "tray",
                "custom/power"
            ],
            // Modules configuration
            // here should be hyprlandModules
            ${hyprlandModulesString}

            "keyboard-state": {
                "numlock": true,
                "capslock": true,
                "format": "{name} {icon}",
                "format-icons": {
                    "locked": "",
                    "unlocked": ""
                }
            },
            //"mpd": {
            //    "format": "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ",
            //    "format-disconnected": "Disconnected ",
            //    "format-stopped": "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ",
            //    "unknown-tag": "N/A",
            //    "interval": 5,
            //    "consume-icons": {
            //        "on": " "
            //    },
            //    "random-icons": {
            //        "off": "<span color=\"#f53c3c\"></span> ",
            //        "on": " "
            //    },
            //    "repeat-icons": {
            //        "on": " "
            //    },
            //    "single-icons": {
            //        "on": "1 "
            //    },
            //    "state-icons": {
            //        "paused": "",
            //        "playing": ""
            //    },
            //    "tooltip-format": "MPD (connected)",
            //    "tooltip-format-disconnected": "MPD (disconnected)"
            //},
            "idle_inhibitor": {
                "format": "{icon}",
                "format-icons": {
                    "activated": "",
                    "deactivated": ""
                }
            },
            "tray": {
                // "icon-size": 21,
                "spacing": 10
            },
            "clock": {
                "timezone": "Europe/Belgrad",
                "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
                "format-alt": "{:%Y-%m-%d}"
            },
            "cpu": {
                "format": "{usage}% ",
                "tooltip": false
            },
            "memory": {
                "format": "{}% "
            },
            "temperature": {
                // "thermal-zone": 2,
                // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
                "critical-threshold": 80,
                // "format-critical": "{temperatureC}°C {icon}",
                "format": "{temperatureC}°C {icon}",
                "format-icons": ["", "", ""]
            },
            "backlight": {
                // "device": "acpi_video1",
                "format": "{percent}% {icon}",
                "format-icons": ["", "", "", "", "", "", "", "", ""]
            },
            "battery": {
                "states": {
                    "good": 70,
                    "warning": 40,
                    "critical": 20
                },
                "format": "{capacity}% {icon}",
                "format-full": "{capacity}% {icon}",
                "format-charging": "{capacity}% ",
                "format-plugged": "{capacity}% ",
                "format-alt": "{time} {icon}",
                // "format-good": "", // An empty format will hide the module
                // "format-full": "",
                "format-icons": ["", "", "", "", ""]
            },
            "power-profiles-daemon": {
              "format": "{icon}",
              "tooltip-format": "Power profile: {profile}\nDriver: {driver}",
              "tooltip": true,
              "format-icons": {
                "default": "",
                "performance": "",
                "balanced": "",
                "power-saver": ""
              }
            },
            "network": {
                // "interface": "wlp2*", // (Optional) To force the use of this interface
                "format-wifi": "{essid} ({signalStrength}%) ",
                "format-ethernet": "{ipaddr}/{cidr} ",
                "tooltip-format": "{ifname} via {gwaddr} ",
                "format-linked": "{ifname} (No IP) ",
                "format-disconnected": "Disconnected ⚠",
                "format-alt": "{ifname}: {ipaddr}/{cidr}"
            },
            "pulseaudio": {
                // "scroll-step": 1, // %, can be a float
                "format": "{volume}% {icon} {format_source}",
                "format-bluetooth": "{volume}% {icon} {format_source}",
                "format-bluetooth-muted": " {icon} {format_source}",
                "format-muted": " {format_source}",
                "format-source": "{volume}% ",
                "format-source-muted": "",
                "format-icons": {
                    "headphone": "",
                    "hands-free": "",
                    "headset": "",
                    "phone": "",
                    "portable": "",
                    "car": "",
                    "default": ["", "", ""]
                },
                "on-click": "pavucontrol"
            },
            //"custom/media": {
            //    "format": "{icon} {}",
            //    "return-type": "json",
            //    "max-length": 40,
            //    "format-icons": {
            //        "spotify": "",
            //        "default": "🎜"
            //    },
            //    "escape": true,
            //    "exec": "$HOME/.config/waybar/mediaplayer.py 2> /dev/null" // Script in resources folder
            //    // "exec": "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
            //},
            "custom/power": {
                "format" : "⏻ ",
        		"tooltip": false,
        		"menu": "on-click",
        		"menu-file": "$HOME/.config/waybar/power_menu.xml", // Menu file in resources folder
        		"menu-actions": {
                "shutdown": "shutdown",
                "reboot": "reboot",
                "suspend": "systemctl suspend",
                "hibernate": "systemctl hibernate"
              }
            }
        }
      '';
    xdg.configFile."waybar/style.css".source = ./style.css;
    xdg.configFile."waybar/power_menu.xml".source = ./power_menu.xml;
  };
}
