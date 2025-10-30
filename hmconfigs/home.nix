{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./rofi.nix
    ./nvim
    ./i3configs/i3config.nix
    ./tmux.nix
    ./zshrc.nix
    ./theme.nix
    ./kitty.nix
    ./polybar/polybar.nix
    ./eww.nix
  ];

  home.username = "nickd";
  home.homeDirectory = "/home/nickd";
  home.stateVersion = "24.05";

  # git config
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "AglarEnGar";
    userEmail = "luca.j.morgan@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };

  # Default applications forced with mimetypes cuz vesktop dong behave
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop"; # Links
      "x-scheme-handler/http" = "firefox.desktop"; # Links
      "x-scheme-handler/mailto" = "firefox.desktop"; # Links
      "application/pdf" = "firefox.desktop"; # pdfs

      # Videos
      "video/mp4" = "vlc.desktop";
      "video/mpeg" = "vlc.desktop";
      "video/ogg" = "vlc.desktop";
      "video/webm" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "video/quicktime" = "vlc.desktop";

      "text/plain" = "vim.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "impress.desktop";

      # Pictures
      "image/png" = "krita_png.desktop";
      "image/jpeg" = "krita_jpeg.desktop";
    };
  };

  # Wallpaper auto loading
  home.file = {
    "/.config/nitrogen/bg-saved.cfg".text = ''
      [xin_1]
      file=/home/nickd/dotfiles/hmconfigs/images/images.steamusercontent2.jpg
      mode=5
      bgcolor=#000000

      [xin_2]
      file=/home/nickd/dotfiles/hmconfigs/images/images.steamusercontent.jpg
      mode=5
      bgcolor=#000000

      [xin_0]
      file=/home/nickd/dotfiles/hmconfigs/images/kenshi1.jpg
      mode=5
      bgcolor=#000000
    '';
  };

  programs.home-manager.enable = true;
}
