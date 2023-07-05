{ config, pkgs, ... }:
let
  mkdnflow-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "mkdnflow-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "jakewvincent";
      repo = "mkdnflow.nvim";
      rev = "5a9768fe09c614600fd2881f29c5cedf931f3e36";
      hash = "sha256-M85FZ1gLplVOF3hKaTAJzSXqqrbKDLburmW8T2eXncY=";
    };
  };
in
{
    home.stateVersion = "23.05";
    home.username = "qq";
    home.homeDirectory = "/home/qq";
    #home.keyboard.options = [ "grp:caps_toggle" ]; don't work

    home.packages = with pkgs; [
        pass  # password manager
        bluez  # bluetooth manager
        acpi
        xclip
        file
        #input remapper 2 hz mb
        p7zip
        unzip

        sent # presentation tool
        bc  # calculator
        ncdu  # memory aviability
        lazygit
        nchat  # tg
        remind  # calendar
        ncspot  # spotify
        sad # batch editing files
        redshift
      
        # qcomicbook
        yt-dlp
        anki
        autokey
        zoom-us
        qbittorrent
        #libreoffice

        ffmpeg_6-full
        screenkey
        imagemagick
        libjxl

        glxinfo
        #heroic
        dolphin-emu
        # if you want to add some packages or libraris to the programm use this
        #wineWowPackages.full
        #lutris
        protonup-qt
        xorg.libX11
        vulkan-tools
        vulkan-loader
        playonlinux
        wineWowPackages.stable
        winetricks
        lutris
        #(lutris.override {
        #    #extraLibraries =  pkgs: [
        #    # List library dependencies here
        #    # ];
        #    extraPkgs = pkgs: [
        #    ];
        #})
        sqlite
        sqlitebrowser
        #(python3.withPackages(ps: with ps; [ pandas requests ]))
    ];
    home.sessionVariables = { # equal to 'export EDITOR="nvim"'
      EDITOR = "${pkgs.neovim}/bin/nvim";
      GIT_PAGER= "${pkgs.delta}/bin/delta";
    };
    programs.home-manager.enable = true;
    programs = {
        git = {
          enable = true;
          userName  = "lumpsoid";
          userEmail = "mmgeeki@gmail.com";
          delta.enable = true; # diff for git
        };
        zsh = {
            enable = true;
            shellAliases = {
              ll = "ls -l";
              upd = "pass sudo | sudo -S nixos-rebuild switch --flake /home/flake#qq";
              nnn = "nnn -e";
            };
            history = {
              path = "${config.xdg.dataHome}/zsh/history";
            };
            enableSyntaxHighlighting = true;
            enableAutosuggestions = true;
            oh-my-zsh = {
                enable = true;
            };
            zplug = {
                enable = false;
                plugins = [ 
                    { name = "MichaelAquilina/zsh-you-should-use"; }
                ];
            };
        };
        oh-my-posh = {
            enable = false;
            enableZshIntegration = true;
            useTheme = "atomicBit";
        };
        z-lua = {
            enable = true;
            enableZshIntegration = true;
        };
        tmux = {
            enable = true;
            shell = "\${pkgs.zsh}/bin/zsh";
            terminal = "st";
        };
        skim = {
            enable = true;
            enableZshIntegration = true;
        };
        nnn = {
          enable = true;
        };
        chromium = {
            enable = true;
        };
        neovim = {
          enable = true;
          plugins = with pkgs.vimPlugins; [
            oil-nvim
            nvim-web-devicons

            nvim-treesitter
            nvim-treesitter-parsers.python
            nvim-treesitter-parsers.lua
            nvim-treesitter-parsers.nix
            nvim-treesitter-parsers.markdown

            vim-xkbswitch
            mkdnflow-nvim
            which-key-nvim
            lualine-nvim
            hop-nvim
            nvim-base16
            fzf-lua
            indent-blankline-nvim
            wilder-nvim
            cmp-nvim-lsp
            cmp-path
            luasnip
            cmp_luasnip
            friendly-snippets
            nvim-autopairs
            nvim-cmp
            plenary-nvim
            mason-nvim
            mason-lspconfig-nvim
            nvim-lspconfig
            null-ls-nvim
            nvim-dap
            nvim-dap-ui
            nvim-dap-python
            magma-nvim-goose
          ];
          extraPackages = with pkgs; [
            nodejs_20  # for mason
          ];
          extraLuaConfig = builtins.readFile ./nvim-config.lua;
        };
        mangohud = {
          enable = true;
          settings = {
            fps_limit = 60;
            vsync = 3;
            gpu_name = true;
          };
        };
        mpv = {
            enable = true;
        };
        zathura = {
            enable = true;
        };
    };
    services = {
        espanso = {
            enable = true;
            matches = {
                default = {
                    matches = [
                        {
                            trigger = ";test";
                            replace = "тест на русском";
                        }
                    ];
                };
            };
        };
    };
    # scripts
    home.file = {
        ".local/bin/test_i_am_here" = { 
            text = ''
                #!${pkgs.bash}/bin/bash
                echo 'I am installed!!!'
            '';
            executable = true;
        };
        # for dwm and st color pallet
        ".Xresources".text = ''
          *.font: Meslo LG S:pixelsize=15
          *.foreground: #F8F8F2
          *.background: #282A36
          *.color0:     #000000
          *.color8:     #4D4D4D
          *.color1:     #FF5555
          *.color9:     #FF6E67
          *.color2:     #50FA7B
          *.color10:    #5AF78E
          *.color3:     #F1FA8C
          *.color11:    #F4F99D
          !*.color4:     #BD93F9
          *.color4:     #fba23d
          !*.color12:    #CAA9FA
          *.color12:    #fba23d
          *.color5:     #FF79C6
          *.color13:    #FF92D0
          *.color6:     #8BE9FD
          *.color14:    #9AEDFE
          *.color7:     #BFBFBF
          *.color15:    #E6E6E6
          *.cursorColor: green
        '';
        ".config/mimeapps.list".text = ''
          [Default Applications]
          inode/directory=nnn.desktop
          text/plain=${pkgs.neovim}/share/applications/nvim.desktop
          text/html=firefox.desktop
          x-scheme-handler/http=firefox.desktop
          x-scheme-handler/https=firefox.desktop
          x-scheme-handler/about=firefox.desktop
          x-scheme-handler/unknown=firefox.desktop
          x-scheme-handler/mailto=firefox.desktop
          audio/*=mpv.desktop
          image/*=sxiv.desktop
          x-scheme-handler/chrome=firefox.desktop
          application/pdf=zathura.desktop;
          application/*=firefox.desktop
        '';
        ".gnupg/gpg-agent.conf".text = ''
          pinentry-program ${pkgs.pinentry-rofi}/bin/pinentry-rofi
        '';
        ".local/share/applications/template.desktop".text = ''
            [Desktop Entry]
            # The type as listed above
            Type=Application
            # The name of the application
            Name=nvim
            # A comment which can/will be used as a tooltip
            Comment=editor
            # The executable of the application, possibly with arguments.
            #Exec=${pkgs.neovim}/bin/nvim
            # Describes whether this application needs to be run in a terminal or not
            #Terminal=true
        '';
        ".xinitrc".text = ''
            #!/bin/sh
            userresources=$HOME/.Xresources
            usermodmap=$HOME/.Xmodmap
            sysresources=/etc/X11/xinit/.Xresources
            sysmodmap=/etc/X11/xinit/.Xmodmap
            # merge in defaults and keymaps
            if [ -f $sysresources ]; then
                xrdb -merge $sysresources
            fi
            if [ -f $sysmodmap ]; then
                xmodmap $sysmodmap
            fi
            if [ -f "$userresources" ]; then
                xrdb -merge "$userresources"
            fi
            if [ -f "$usermodmap" ]; then
                xmodmap "$usermodmap"
            fi
            # start some nice programs
            if [ -d /etc/X11/xinit/xinitrc.d ] ; then
             for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
              [ -x "$f" ] && . "$f"
             done
             unset f
            fi
            #mailsync &
            #remind -z -k'gxmessage -title "reminder" %s &' ~/.config/remind/uni.rem & 
            autokey-gtk &
            lxqt-policykit-agent &
            dunst &
            dwmblocks &
            exec dwm
        '';
        ".local/bin/sc-screenshootsh" = {
            text = ''
                #!/bin/sh
                #imagemagick package
                #xclip package
                #if pgrep "Xorg" > /dev/null; then
                timestamp=$(date +%Y%m%d%H%M%S) &&
                import /tmp/$timestamp.png &&
                cat /tmp/$timestamp.png | xclip -selection clipboard -target image/png -i | notify-send 'screenshot done' &&
                cjxl /tmp/"$timestamp".png ~/Pictures/Screenshots/"$timestamp".jxl -q 60 --num_threads=4 &&
                rm /tmp/"$timestamp".png &&
                #    exit;
                #fi
                if pgrep "river" > /dev/null; then
                    timestamp=$(date +%Y%m%d%H%M%S) &&
                    grim -g "$(slurp)" /tmp/"$timestamp".png &&
                    wl-copy < /tmp/"$timestamp".png &&
                    cjxl /tmp/"$timestamp".png ~/Pictures/Screenshots/"$timestamp".jxl -q 60 --num_threads=4 &&
                    rm /tmp/"$timestamp".png &&
                    exit;
                fi
                '';
            executable = true;
        };
    };
}
