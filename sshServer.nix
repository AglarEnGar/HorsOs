{
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    startAgent = true;
  };
  services.openssh = {
    enable = true;
    ports = [10001];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [
        "guest"
      ];
    };
  };
  services.fail2ban.enable = true;

  services.endlessh = {
    enable = true;
    port = 22;
    openFirewall = true;
  };

  # Create the guest user with restricted access
  users.users.guest = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$POzFaPSuGzXGzrc0p9upq.$e32LRoe9zd7xpJgRhzW4skbJuzrNcwRTTqqZ/TqmZr/";
    home = "/home/guest";
    createHome = true;
    group = "repository";
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmdKF4/iYZFKSVXlJUl/6o6K9lF9ul3ToKp450mSYmU luca.j.morgan@gmail.com" # laptop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9oYLYzCVdTnxWcT7oZWhJYU/xNNAfGyzkapJxK4n3s u0_a390@localhost" # phone
    ];
  };

  users.groups.repository = {};

  # 1. SSH Config
  services.openssh.extraConfig = ''
    Match User guest
      ChrootDirectory /var/jail
  '';

  fileSystems."/var/jail/run/current-system/sw/bin" = {
    device = "/run/current-system/sw/bin";
    options = ["bind" "ro"];
  };

  fileSystems."/var/jail/dev/pts" = {
    device = "devpts";
    fsType = "devpts";
    # These options are critical for security in a chroot
    options = ["nosuid" "noexec" "newinstance" "mode=620" "gid=5"];
  };

  # 2. Set up the Jail Filesystem
  # We use fileSystems to bind mount the Nix store and essential paths
  fileSystems."/var/jail/nix/store" = {
    device = "/nix/store";
    options = ["bind" "ro"];
  };

  fileSystems."/var/jail/bin" = {
    device = "/run/current-system/sw/bin";
    options = ["bind" "ro"];
  };

  fileSystems."/var/jail/proc" = {
    device = "proc";
    fsType = "proc";
    options = ["nosuid" "noexec" "nodev"];
  };

  # 3. Create necessary directories and symlinks
  systemd.tmpfiles.rules = [
    # The jail root must be root:root 755
    "d /var/jail 0755 root root - -"
    "d /var/jail/run/current-system/sw/bin 0755 root root - -"
    "d /var/jail/proc 0555 root root - -"
    "d /var/jail/nix/store 0755 root root - -"
    "d /var/jail/bin 0755 root root - -"
    "d /var/jail/tmp 1777 root root - -"

    # make the home
    "d /var/jail/home/guest 0700 guest repository - -"

    # Optional: If you need /dev (often needed for interactive shells)
    "d /var/jail/dev 0755 root root - -"
    "c /var/jail/dev/null    0666 root root - 1:3"
    "c /var/jail/dev/zero    0666 root root - 1:5"
    "d /var/jail/dev/pts 0755 root root - -" # Directory for the devpts mount
    "c /var/jail/dev/tty     0666 root root - 5:0"
    "c /var/jail/dev/urandom 0666 root root - 1:9"
    "c /var/jail/dev/random  0666 root root - 1:8"

    "c /var/jail/dev/ptmx 0666 root root - 5:2"
  ];

  # services.ddclient = {
  #   enable = true;
  #   username = "mw75vc5";
  #   # passwordFile = "/etc/nixos/passwd.txt";
  #   protocol = "noip";
  # services.ddclient.ssl = true;
  #   extraConfig = ''
  #     use=web
  #     daemon=300
  # 	password=2bKWGmEEfQsR
  #   '';
  #   domains = [
  #     "sourcecontrol.myftp.org"
  #   ];
  # };
}
