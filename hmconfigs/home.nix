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

  programs.home-manager.enable = true;
}
