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
    ../../modules/apps/mtkclient/default.nix
    ../../modules/terminal_app/nvim/nixvim.nix
    ../../modules/windowManagers/hyprland/default.nix
    ../../modules/windowManagers/awesome/default.nix
  ];
  # Bootloader.
  #boot.kernelParams = ["psmouse.elantech_smbus=0"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-946adcd6-e77f-4d01-8062-6a2dc676f7ec".device = "/dev/disk/by-uuid/946adcd6-e77f-4d01-8062-6a2dc676f7ec";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #services.connman.enable = true;
  networking.networkmanager.enable = true;

  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Belgrade";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the Enlightenment Desktop Environment.
  #services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  #services.displayManager.sddm = {
  #  enable = true;
  #  wayland.enable = true;
  #};

  # Enable acpid
  services.acpid.enable = true;

  services.upower.enable = true;

  security = {
    polkit.enable = true;

    sudo = {
      enable = true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/systemctl suspend";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/systemctl hibernate";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/poweroff";
              options = ["NOPASSWD"];
            }
          ];
          groups = ["wheel"];
        }
      ];
    };
  };
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
    powerManagement.enable = true;
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

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["0xProto"];})
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["0xProto"];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.qq = {
    isNormalUser = true;
    description = "qq";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "docker"
    ];
    packages = with pkgs; [
      android-udev-rules
      alejandra
      fossil
      libreoffice-qt6
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    ];
  };
  programs.fish.enable = true;
  programs.adb.enable = true;
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/home/qq/Documents/programming/docker/data/";
  };

  module = {
    windowManager = {
      hyprland.enable = true;
      awesome.enable = true;
    };
    mtkclient = {
      enable = false;
      user = "qq";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users = {
      "qq" = import ./home.nix;
    };
  };

  programs = {
    # Install firefox.
    firefox.enable = true;
    light.enable = true;
    nix-ld = {
      enable = true;
    };
    ssh.startAgent = true;
    dconf.enable = true;

    tmux = {
      enable = true;
      escapeTime = 10;
    };
    appimage.binfmt = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    imagemagick
    libnotify
    lxqt.lxqt-policykit
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
    zip
    unzip
    keepassxc
    rsync
    ps_mem
    gimp
    fend
    trashy
    appimage-run
    jq
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
