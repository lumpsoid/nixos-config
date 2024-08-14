# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];
  # Bootloader.
  boot.kernelParams = ["psmouse.elantech_smbus=0"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-946adcd6-e77f-4d01-8062-6a2dc676f7ec".device = "/dev/disk/by-uuid/946adcd6-e77f-4d01-8062-6a2dc676f7ec";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  services.connman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Belgrade";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    xset r rate 300 30
  '';

  # Enable the Enlightenment Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      vicious
    ];
  };

  # Enable acpid
  services.acpid.enable = true;

  services.upower.enable = true;

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  environment = {
    #shells = with pkgs; [ zsh ];
    sessionVariables = rec {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
    localBinInPath = true;
    variables = {
      EDITOR = "nvim";
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    variant = ",typewriter";
    options = "grp:caps_toggle";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
  };

  services.xserver.videoDrivers = ["amdgpu" "nvidia"];
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      _0xproto
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["0xProto"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.qq = {
    isNormalUser = true;
    description = "qq";
    extraGroups = ["networkmanager" "wheel" "video" "adbusers" "docker"];
    shell = pkgs.fish;
    packages = with pkgs; [
      #  thunderbird
      vscode
      flutter
      android-studio
      android-udev-rules
      alejandra
    ];
  };
  programs.fish.enable = true;
  programs.adb.enable = true;
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/home/qq/Documents/programming/docker/data/";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users = {
      "qq" = import ./home.nix;
    };
  };

  # Install firefox.
  programs = {
    firefox.enable = true;
    light.enable = true;
    nix-ld = {
      enable = true;
    };
    ssh.startAgent = true;
    dconf.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    libnotify
    xdg-desktop-portal
    lxqt.lxqt-policykit
    neovim
    sxiv
    mpv
    tldr
    btop
    dua
    ripgrep
    fzf
    git
    lazygit
    xclip
    ranger
    unzip
    keepassxc
    rsync
    ps_mem
    gimp
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
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
  system.stateVersion = "24.05"; # Did you read the comment?
}
