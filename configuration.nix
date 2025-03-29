{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./zsh.nix
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Drivers settings
  hardware.graphics = {
    enable = true;
  };
  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  # Networko
  networking = {
    #    firewall = {
    #      enable = true;
    #      allowedTCPPorts = [];
    #      allowedUDPPorts = [];
    #    };
    hostName = "HorsOs";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_CTYPE = "en_US.utf8"; # required by dmenu don't change this
  };

  # find my desktop managers
  services = {
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
        ];
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      # The special series of scripts that run before login to make sure its on
      # the right monitor
      displayManager.lightdm = {
        enable = true;
        extraSeatDefaults = ''
          display-setup-script=${pkgs.writeScript "lightdm-display-setup" ''
            #!/bin/sh
            # Wait for X to be ready (LightDM runs this automatically, but just in case)
            while [ ! -e /tmp/.X11-unix/X0 ]; do sleep 0.1; done

            # Set primary display (replace HDMI-1 with your actual primary monitor)
            ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --primary

            # Disable other displays (replace DP-1 with your secondary monitor)
            ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --off

            # Disable other displays (replace DP-1 with your secondary monitor)
            ${pkgs.xorg.xrandr}/bin/xrandr --output HDM1-2 --off
          ''}
        '';
      };
      # the goofy login menu
      displayManager.lightdm.greeters.mini = {
        enable = true;
        user = "nickd";
        extraConfig = ''
          [greeter]
          show-password-label = false
        '';
      };
      xrandrHeads = [
        "DP-2"
      ];
    };
    displayManager = {
      defaultSession = "xfce+i3";
    };
    gvfs.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  services.autorandr = {
    enable = true;
  };

  environment.xfce.excludePackages = with pkgs.xfce; [
    xfce4-taskmanager
    xfce4-terminal
    xfce4-appfinder
  ];

  # Set up picom as a service
  services.picom = {
    enable = true;
    settings = {
      blur = {
        method = "kernel";
        strength = 5;
      };
      backend = "glx";
      inactive-opacity = 0.8;
      active-opacity = 1.0;
      opacity-rule = [
        "95:class_g = 'kitty' && focused"
        "85:class_g = 'kitty' && !focused"
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };

  users.users.nickd = {
    isNormalUser = true;
    description = "Nickd Dyson";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
      xarchiver
    ];
  };

  # flatpak enable
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  services.flatpak.enable = true;

  # Find my packages
  environment.systemPackages = with pkgs; [
    nixops
    maim
    scrot
    slop
    ffcast
    libnotify
    imagemagick
    rofi-screenshot
    numlockx
    rofi
    xclip
    lact
    baobab
    vlc
    playerctl
    lxappearance
    xfce.xfce4-clipman-plugin
    lightdm-gtk-greeter
    linux-manual
    man-pages
    man-pages-posix
    sl
    bear
    valgrind
    gdb
    btop
    tree
    calibre
    mangohud
    tmux
    vscode
    libreoffice
    lsd
    winetricks
    protonup-qt
    gparted
    gnumake
    pinta
    volantes-cursors
    volantes-cursors
    gcc
    wineWowPackages.stable
    jq
    distrobox
    fastfetch
    spotify
    deluge
    chromium
    fd
    ripgrep
    starship
    kitty
    dmenu
    git
    networkmanagerapplet
    nitrogen
    pasystray
    polkit_gnome
    pulseaudioFull
    vim
    neovim
    unrar
    unzip
    lshw
    usbutils
    pciutils
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vkcapture
      ];
    })
  ];

  # Something else about obs
  #  boot.extraModprobeConfig = ''
  #    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  #  '';
  #  boot.initrd.kernelModules = ["wl"];

  # virtualization
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # input remper
  services.input-remapper.enable = true;

  # steam setup an config
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.nix-ld.enable = true;

  environment.sessionVariables = {
    TERMINAL = "kitty";
    CURSOR_THEME = "volantes_cursors";
    EDITOR = "vim";
  };

  # fonts and themes
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
    ];

    fontconfig = {
      defaultFonts = {
        monospace = ["FiraCode Nerd Font"];
      };
    };
  };

  # flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # enable home manager
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "nickd" = import ./hmconfigs/home.nix;
    };
  };

  programs = {
    thunar.enable = true;
    dconf.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  hardware = {
    bluetooth.enable = true;
  };

  # Don't touch this
  system.stateVersion = "23.05";
}
