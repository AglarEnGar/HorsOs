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

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.kernelModules = ["kvm-amd" "v4l2loopback"];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

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
          password-alignment = middle

          [greeter-theme]
          background-image = "/etc/lightdm/IMG_0280.jpg"
          window-color = "#AA5632"
          font = "monospace"
          border-color = "#000000"
          layout-space = 10
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

  # Users
  users.users.nickd = {
    isNormalUser = true;
    description = "Nickd Dyson";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      vesktop
      firefox
      xarchiver
    ];
  };

  # Printer setup and cofig
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.drivers = [
    pkgs.brlaser
    pkgs.brgenml1lpr
    pkgs.brgenml1cupswrapper
  ];
  #hardware.printers = {
  #  ensurePrinters = [
  #    {
  #      name = "Brother_MFC_J6710DW";
  #      location = "Home";
  #      deviceUri = "usb://Brother/MFC-J6710DW?serial=BROJ1F479139";
  #      model = "everywhere";
  #      ppdOptions = {
  #        PageSize = "A4";
  #      };
  #    }
  #  ];
  #};

  # flatpak enable
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  services.flatpak.enable = true;

  # Find my packages
  environment.systemPackages = with pkgs; [
    blender-hip
    qbittorrent
    dnscrypt-proxy
    git-lfs
    calcurse
    nodejs
    cmake
    wget
    clang-tools
    llvmPackages.clangUseLLVM
    nvtopPackages.amd
    python3
    qalculate-qt
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
    kitti3
    dmenu
    git
    networkmanagerapplet
    nitrogen
    pasystray
    polkit_gnome
    pulseaudioFull
    system-config-printer
    webcamoid
    vim
    tmux
    neovim
    unrar
    unzip
    lshw
    inetutils
    nmap
    lsof
    wmctrl
    alsa-utils
    bmon
    wirelesstools
    usbutils
    pciutils
    zoxide
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vkcapture
      ];
    })
  ];

  # virtualization
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # input remper
  services.input-remapper.enable = true;

  programs = {
    # steam setup an config
    gamemode.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    nix-ld.enable = true;

    # setting up htop
    htop = {
      enable = true;
      settings.show-cpu-temperature = 1;
    };
  };

  environment.sessionVariables = {
    TERMINAL = "kitty";
    CURSOR_THEME = "volantes_cursors";
    BROWSER = "/etc/profiles/per-user/nickd/bin/firefox";
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
