{pkgs, ...}: let
  user = "nickd";
  flakePath = "/home/${user}/dotfiles";
in {
  systemd.services = {
    flake-update = {
      description = "Update flake inputs";
      unitConfig = {
        StartLimitIntervalSec = 300;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        ExecStartPre = "${pkgs.networkmanager}/bin/nm-online";
        ExecStart = "${pkgs.nix}/bin/nix flake update --flake ${flakePath}";
        Restart = "on-failure";
        RestartSec = "30";
        Type = "oneshot";
        User = "${user}";
      };
      path = [
        pkgs.nix
        pkgs.git
        pkgs.host
        pkgs.networkmanager
      ];
    };
  };

  systemd.services.nixos-upgrade = {
    after = ["flake-update.service"];
    requires = ["flake-update.service"];
  };

  system.autoUpgrade = {
    enable = true;
    flags = ["--print-build-logs"];
    flake = "path://${flakePath}";
  };

  # On my desktop its set to midnight, on other devices I set it to 1:00
  system.autoUpgrade.dates = "0:00";
}
