{pkgs, ...}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      theme = "robbyrussell";
      enable = true;
      plugins = ["sudo" "git" "aws"];
    };

    shellAliases = {
      vim  = "TERM=screen-256color vi";
      tmux = "tmux -2";
    };
  };

  users.defaultUserShell = pkgs.zsh;
}
