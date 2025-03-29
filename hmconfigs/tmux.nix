{pkgs, config, ...}:
{
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      sensible
    ];

    extraConfig = ''
      set -g pane-border-style fg=#6668ba
    '';
  };
}
