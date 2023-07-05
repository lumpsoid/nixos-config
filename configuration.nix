# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.polkit.enable = true;
  #boot.kernelParams = [ "acpi_backlight=native" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Belgrade";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

  };
  environment.localBinInPath = true;  # .local/bin in PATH

  # Configure X11
  services.xserver = {
    enable = true;
    autorun = false;
    videoDrivers = [ "amdgpu" "nvidia" ];

    displayManager.startx.enable = true;
    windowManager.dwm.enable = true;

    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
      touchpad.accelProfile = "flat";
      #mouse.sendEventsMode = "disabled";
    };
    inputClassSections = [''
          Identifier "laptop mouse input"
          MatchDriver "libinput"
          MatchIsPointer "on"
          MatchProduct "ELAN0752:00 04F3:31C2 Mouse"
          Option "SendEventsMode" "disabled"
    ''];
    synaptics.enable = false;
    layout = "us,ru(typewriter)";
    xkbOptions = "grp:caps_toggle";
  };
  #services.xserver.displayManager.sessionCommands = "";

  security.rtkit.enable = true; # for pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;
  };
  
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    meslo-lg
    nerdfonts
  ];
  fonts.fontconfig.defaultFonts.monospace = [ "Meslo LG M" ];

  hardware = {
      bluetooth.enable = true;
      opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
          setLdLibraryPath = true;
      };
      nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true;
          nvidiaSettings = true;
          open = true;
          prime = {
              offload = {
                  enable = true;
                  enableOffloadCmd = true;
              };
              nvidiaBusId = "PCI:1:0:0";
              amdgpuBusId = "PCI:07:0:0";
          };
      };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
    (st.overrideAttrs (oldAttrs: rec {
      src = fetchFromGitHub {
        owner = "LukeSmithxyz";
        repo = "st";
        rev = "8ab3d03681479263a11b05f7f1b53157f61e8c3b";
        sha256 = "1brwnyi1hr56840cdx0qw2y19hpr0haw4la9n0rqdn0r2chl8vag";
      };
      # Make sure you include whatever dependencies the fork needs to build properly!
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
      #configFile = writeText "config.h" (builtins.readFile ./st-config.h);
      #postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.h";
    # If you want it to be always up to date use fetchTarball instead of fetchFromGitHub
    # src = builtins.fetchTarball {
    #   url = "https://github.com/lukesmithxyz/st/archive/master.tar.gz";
    # };
    }))
    dwmblocks
    git
    gnupg
    
    glib # for dunst
    libnotify # for dunst
    dunst
    
    tldr
    vim
    curl
    wget
    htop
    rofi
    pinentry-rofi
    firefox
    sxiv

    zsh
    zplug
    silver-searcher
  ];

  programs.light.enable = true;
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        src = super.fetchFromGitHub {
          owner = "lumpsoid";
          repo = "dwm";
	      rev = "71560451d171b4fce469d1e6f6c3d21a0900a3ee";
	      sha256 = "21fD75ZNwXdFElVxC6gb6xeceom21our2/QJqe5lQNs=";
        };
        configFile = super.writeText "config.h" (builtins.readFile ./dwm-config.h);
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.h";
      });
      dwmblocks = super.dwmblocks.overrideAttrs (oldAttrs: rec {
        src = super.fetchFromGitHub {
            owner = "lumpsoid";
            repo = "dwmblocks";
            rev = "31279f6f16899b6930e0fac47ae39cd5f4261d1c";
            sha256 = "Mvz4jIG4E9tY5u3kFn5vum4BDXWiJx9blpAhOHG1VI0=";
        };
        configFile = super.writeText "config.h" (builtins.readFile ./dwmblocks-config.h);
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.h";
      });
    })
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.groups.video = {};
  users.defaultUserShell = pkgs.zsh;
  users.users.qq = {
    isNormalUser = true;
    description = "qq";
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  services.picom.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.lxqt.xdg-desktop-portal-lxqt
    ];
  };
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
 
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
