{
  pkgs,
  config,
  lib,
  ...
}: {
  gtk = {
    enable = true;

    iconTheme = lib.mkForce {
      name = "Numix-Circle";
      package = pkgs.numix-icon-theme-circle;
    };

    cursorTheme = {
      package = pkgs.volantes-cursors;
      name = "volantes_cursors";
    };

    # theme = {
    #   name = "Catppuccin-Macchiato-Lavender";
    #   package = pkgs.catppuccin-gtk.override {
    #     accents = ["lavender"];
    #     variant = "macchiato";
    #     tweaks = ["rimless" "black"];
    #   };
    # };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # xdg.configFile = {
  #   "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
  #   "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
  #   "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  # };
}
