{
  pkgs,
  config,
  ...
}: {
  programs.eww = {
    enable = true;
  };

  xdg.configFile."eww".source = ./eww;
}
