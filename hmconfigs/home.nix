{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    ./rofi.nix
    ./nvim
    ./i3configs/i3config.nix
    ./tmux.nix
    ./zshrc.nix
    ./theme.nix
    ./kitty.nix
    ./polybar/polybar.nix
  ];

  home.username = "nickd";
  home.homeDirectory = "/home/nickd";
  home.stateVersion = "24.05";

  # git config
  programs.git = {
    enable = true;
    userName = "AglarEnGar";
    userEmail = "luca.j.morgan@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };

  home.file = {
    "/.config/nitrogen/bg-saved.cfg".text = ''
      [xin_1]
      file=/home/nickd/dotfiles/hmconfigs/images/images.steamusercontent2.jpg
      mode=5
      bgcolor=#000000

      [xin_0]
      file=/home/nickd/dotfiles/hmconfigs/images/images.steamusercontent.jpg
      mode=1
      bgcolor=#000000

      [xin_2]
      file=/home/nickd/dotfiles/hmconfigs/images/kenshi1.jpg
      mode=5
      bgcolor=#000000
    '';
  };
  home.file = {
    "/.config/nitrogen/nitrogen.cfg".text = ''
      [geometry]
      posx=2018
      posy=38
      sizex=634
      sizey=474

      [nitrogen]
      view=icon
      recurse=true
      sort=rtime
      icon_caps=false
      dirs=/home/nickd/dotfiles/images;
    '';
  };
  programs.home-manager.enable = true;
}
