{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./zsh.nix
    ./swapStuff.nix
		./nixos.nix
    # ./sshServer.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # kernel shitfuckery
  boot.kernelParams = [
    "quiet"
    "libahci.ignore_sss=1"
  ];
	boot.kernelModules = ["wl" "v4l2loopback"];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  # Gpu stuff
  # boot.initrd.systemd.network.wait-online.enable = false;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-vkcapture
    ];
    enableVirtualCamera = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Virt- manager and stuff
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Video Card Drivers settings
  boot.kernelPackages = pkgs.linuxPackages;

  hardware.graphics.enable = true;
  hardware.nvidia = {
	  modesetting.enable = true;
	  powerManagement.enable = true;
	  powerManagement.finegrained = true;
	  open = true;
	  nvidiaSettings = true;
	  package = config.boot.kernelPackages.nvidiaPackages.stable;
	  prime = {
		  offload = {
			  enable = true;
			  enableOffloadCmd = true;
		  };
		  sync.enable =  false;    

		  # sync.enable = true; # uses gpu LOTS. maybe will be loud. maybe power consumption.
				      # otheroption sucks penis tho
		  nvidiaBusId = "PCI:1:0:0";
		  intelBusId = "PCI:0:2:0";
	  };
  };

	# help laptop
	services.thermald.enable = true;
	services.tlp = {
  enable = true;
  settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 20;

    # Optional helps save long term battery health
    START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
    STOP_CHARGE_THRESH_BAT0 = 99;  # 80 and above it stops charging
  };
};

  # Networko
  networking = {
    #    firewall = {
    #      enable = true;
    #      allowedTCPPorts = [];
    #      allowedUDPPorts = [];
    #    };
    hostName = "horsos"; # Define your hostname.
    networkmanager.enable = true;
  };

  # wireless thingy for connect school
  networking.networkmanager.wifi.backend = "iwd";

  programs.traceroute.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.resolved = {
    enable = true;
    # dnssec = "true";
    # domains = ["~."];
    # fallbackDns = [
    #   "1.1.1.1"
    #   "1.0.0.1"
    # ];
    # dnsovertls = "true";
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

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 30d";
  };

  # find my desktop managers
  services = {
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
      enable = true;
  		videoDrivers = ["nvidia"];
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
      displayManager.lightdm = {
        enable = true;
      };

      # the goofy login menu
      displayManager.lightdm.greeters.mini = {
        enable = true;
        user = "lucam";
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
			  #sound card shitfuckery
			extraConfig.pipewire-pulse."92-low-latency" = {
				"context.properties" = [
				{
					name = "libpipewire-module-protocol-pulse";
					args = {};
				}
				];
				"pulse.properties" = {
					"pulse.min.req" = "512/48000";
					"pulse.default.req" = "512/48000";
					"pulse.max.req" = "512/48000";
					"pulse.min.quantum" = "512/48000";
					"pulse.max.quantum" = "512/48000";
				};
				"stream.properties" = {
					"node.latency" = "512/48000";
					"resample.quality" = 1;
				};
			};
    };
  };

  environment.xfce.excludePackages = with pkgs; [
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
        "98:class_g = 'kitty' && focused"
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
  services.pulseaudio.enable = false;

  # Users
  users.users.lucam = {
    isNormalUser = true;
    description = "Nick Dyson";
    extraGroups = ["networkmanager" "wheel" "wireshark"];
    packages = with pkgs; [
      vesktop
      firefox
      xarchiver
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmdKF4/iYZFKSVXlJUl/6o6K9lF9ul3ToKp450mSYmU luca.j.morgan@gmail.com" # laptop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9oYLYzCVdTnxWcT7oZWhJYU/xNNAfGyzkapJxK4n3s u0_a390@localhost" # phone
    ];
  };

  # Printer setup and cofig
  # services.printing.enable = true;
  # services.printing.drivers = [
  #   pkgs.brlaser
  # ];
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

  services.mullvad-vpn.enable = true;
  services.tor = {
    enable = true;
    openFirewall = true;
  };

  # flatpak enable
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-xapp
    ];
    config.common."org.freedesktop.impl.portal.Settings" = "gtk";
  };
  services.flatpak.enable = true;

  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  # Find my packagessysctl
  environment.systemPackages = with pkgs; [
		acpi
		ffmpeg
    javaPackages.compiler.temurin-bin.jre-25
    prismlauncher
    unityhub
    spotifywm
    soco-cli
    postgresql
    dropbox
    p7zip
    opensnitch-ui
    gitFull
    (blender.override {rocmSupport = true;})
    net-tools
    godot
    mullvad-vpn
    cataclysm-dda-git
    tasktimer
    whois
    r2modman
    tor-browser
    dotnetCorePackages.sdk_9_0-bin
    wget
    qbittorrent
    dnscrypt-proxy
    calcurse
    nvtopPackages.nvidia
    qalculate-qt
    python3
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
    xfce4-clipman-plugin
    lightdm-gtk-greeter
    linux-manual
    man-pages
    man-pages-posix
    sl
    bear
    valgrind
    gdb
    (btop.override {rocmSupport = true;})
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
    krita
    volantes-cursors
    gcc
    wineWow64Packages.stable
    jq
    distrobox
    fastfetch
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
    # nitrogen
		feh
    pasystray
    polkit_gnome
    pulseaudioFull
    system-config-printer
    webcamoid
    tmux
    unrar
    unzip
    zip
    lshw
    traceroute
    dig
    nmap
    lsof
    wmctrl
    alsa-utils
    bmon
    mlocate
    wirelesstools
    usbutils
    pciutils
    zoxide
    cmake
    xmodmap
    inxi
    psmisc
		bc
  ];

  services.udev = {
    extraRules = ''
      SUBSYSTEM=="dumpcap", GROUP="wireshark", MODE="0640"
    '';
  };
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

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
    nix-ld = {
      enable = true;
    };

    # setting up htop
    htop = {
      enable = true;
      settings.show-cpu-temperature = 1;
    };
  };

  environment.sessionVariables = {
    TERMINAL = "kitty";
    CURSOR_THEME = "volantes_cursors";
    BROWSER = "/etc/profiles/per-user/lucam/bin/firefox";
    EDITOR = "vim";
  };
  environment.variables = {
    XDG_CURRENT_DESKTOP = "XFCE";
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

  # enable home manager
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "lucam" = import ./hmconfigs/home.nix;
    };
  };

  programs = {
    thunar.enable = true;
    dconf.enable = true;
  };
  services.tumbler.enable = true;

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
