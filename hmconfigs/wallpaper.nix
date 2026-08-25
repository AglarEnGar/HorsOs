{ pkgs, ... }:

let
  left   = ./images/images.steamusercontent.jpg;
  center = ./images/images.steamusercontent2.jpg;
  right  = ./images/kenshi1.jpg;
in
{
  home.packages = [ pkgs.feh ];

  systemd.user.services.feh-wallpaper = {
    Unit = {
      Description = "Set multi-monitor wallpaper using feh";
      # Ensures the service waits until the display and window manager are ready
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      # Combined command setting wallpapers for left, center, and right monitors
      ExecStart = "${pkgs.feh}/bin/feh --no-xinerama --bg-fill ${right}";
      RemainAfterExit = true;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

