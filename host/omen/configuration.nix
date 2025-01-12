# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/mtkclient/default.nix
    ../../modules/editors/nvim/nixvim.nix
  ];

  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-946adcd6-e77f-4d01-8062-6a2dc676f7ec".device = "/dev/disk/by-uuid/946adcd6-e77f-4d01-8062-6a2dc676f7ec";

  # mouse fix (not working?)
  boot.kernelParams = ["psmouse.elantech_smbus=0"];

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
  #services.xserver.displayManager.gdm.enable = true;
  #services.displayManager.sddm = {
  #  enable = true;
  #  wayland.enable = false;
  #};

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  # Enable acpid
  services.acpid.enable = true;

  services.upower.enable = true;

  services.logind.lidSwitch = "hibernate";

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
  nix = {
    settings = {
      trusted-users = ["root" "qq"];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };

  services.gnome.gnome-keyring.enable = true;

  environment = {
    #shells = with pkgs; [ zsh ];
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      #If your cursor becomes invisible
      #WLR_NO_HARDWARE_CURSORS = "1";
      #Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      WLR_NO_HARDWARE_CURSORS = 1;
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
      #XDG_CURRENT_DESKTOP = "Hyprland";
      #XDG_SESSION_DESKTOP = "Hyprland";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
    localBinInPath = true;
    variables = {
      EDITOR = "nvim";
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
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

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
  hardware = {
    # then enabling pipewire
    pulseaudio.enable = false;

    bluetooth.enable = true;

    graphics = {
      enable = true;
    };
    nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
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
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "docker"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      android-udev-rules
      alejandra
      fossil
      libreoffice-qt6
      ntfs3g
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    ];
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/home/qq/Documents/programming/docker/data/";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};

    backupFileExtension = "backup";

    users = {
      "qq" = import ./home.nix;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
    knownHosts = {
      "termux" = {
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKlCt3zpKlGn+gaA/U0zpsUT8haMHkt29EqvLv56bYTcgTOjJ0zI0FJHcsgSbWcYmcndjOC8G1tly7SOh7FqWsFNzVRGQo5p6lCA2dCbmISMWbf25wYxUfTqNmKpz6O+mWUM27kFyTmCZs9vPSfhD/BhAM2636cioGsG5wjVYfa3dkvbPA4En+QTjnVgdHHrc8rBBZyIvxT42Oa9nxAhQYZK8oMte2s1iOvrjWwlkcWbFhl0KFEBIDL30p8NTw0J6VdVNT8lNghR4rEqnMQbb9FFCvQRE9HvYK6Tk2MmphZ2YFtfmnwilCfcQuea8Utp5A74bv0WjtoDeLZJR9l4QEt1qngwfZLUlPxufJnMsIKhr1evrP3IT/X8XI+9iSnTcXPT+p0CDBFQn5yh61FkZVraTe823wuSVn2Fk6gQ0GkmamFrU9RJaLwD7/rn2Rt1UoEyE4/LEShAFef4yoOmteg+mBSsPdZL8NmYejPRJRDKRitxRET+ygaD39RdFvXHtzeL4CDbFHFIl+3OXzsr8f8Ydil09TQzfD9TJ9maoZ66TDek8K0oXNRgxc8GDJ8wpx91QBcWbrMNVyZmOOEU6VsArS98PS0egV4UNlfqKeCVz7rCycsqDS1Vqg28g/UZjPDojrFQre4ochd4TxRbCwqRGPVieXz7gUOH6RSbfhZQ==";
      };
    };
  };
  programs = {
    gnupg.agent = {
      enable = true;
      #enableSSHSupport = true;
    };
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
    adb.enable = true;

    fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };

    zsh = {
      enable = true;
      histSize = 4000;
      setOptions = [
        "HIST_IGNORE_DUPS"
        "SHARE_HISTORY"
        "HIST_FCNTL_LOCK"
        "HIST_EXPIRE_DUPS_FIRST"
        "HIST_REDUCE_BLANKS"
      ];
    };
  };

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-gtk
  #   ];
  # };

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
    streamlink
    tldr
    btop
    dua
    ripgrep
    fzf
    git
    lazygit
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
    tree
    file
    nix-index
    shadowsocks-libev
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
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      1080
      4000
    ];
  };

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
