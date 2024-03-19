# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.kernelParams = [ "psmouse.elantech_smbus=0" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Configure keymap in X11
  #services.xserver = {
  #  layout = "us";
  #  xkbVariant = "";
  #};
  security.polkit.enable = true;
  
  environment = {
    #shells = with pkgs; [ zsh ];
    sessionVariables = rec {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
    localBinInPath = true;
  };

  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
  
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      meslo-lg
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      monospace = ["Meslo LG M" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
  #console.font = "Meslo LG M";

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    bluetooth.enable = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" "nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:7:0:0";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    groups = {
      seat = {};
    };
    #defaultUserShell = pkgs.zsh;
    users.qq = {
      isNormalUser = true;
      description = "qq";
      extraGroups = [ "networkmanager" "wheel" "seat" "video" ];
      packages = with pkgs; [];
    };
  };

  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    users = {
      "qq" = import ./home.nix;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    dunst
    libnotify
    sxiv
    mpv
    tldr
    btop
    dua
    bc
    lshw
    git 
    vim
    dbus
    wayland
    seatd
    wdisplays
    xdg-utils
    grim
    slurp
    glib
    zulu # java 
    nix-index
    ripgrep
    file
    appimage-run
    pzip
    #xorg.libX11
    #qemu
    #libpulseaudio
    #zlib
  ]; 
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.light.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    #xorg.libX11
    #qemu
    #libpulseaudio
    #zlib
  ];
  #programs.zsh.enable = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.gnome.gnome-keyring.enable = true;

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
  system.stateVersion = "23.11"; # Did you read the comment?

}
