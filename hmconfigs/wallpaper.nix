{ pkgs, ... }:

let
  # Define your 3 wallpapers (local relative paths or fetchurl)
  left   = ./images/images.steamusercontent.jpg;
  center = ./images/images.steamusercontent2.jpg;
  right  = ./images/kenshi1.jpg;
in
{
  home.packages = [ pkgs.feh ];

  xsession.windowManager.i3.config.startup = [
    {
      # List the wallpapers in order from left-most monitor to right-most monitor
      command = "${pkgs.feh}/bin/feh --bg-fill ${right} ${left} ${center}";
      always = true; # Re-apply when i3 restarts
      notification = false;
    }
  ];
}
