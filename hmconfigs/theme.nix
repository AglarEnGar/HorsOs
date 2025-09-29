{
  pkgs,
  config,
	lib,
  ...
}: {
	catppuccin = {
		enable = true;
		accent = "lavender";
		flavor = "macchiato";
	};

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

    gtk3.extraConfig = {
        gtk-application-prefer-dark-theme= true;
    };

    gtk4.extraConfig = {
        gtk-application-prefer-dark-theme= true;
    };

  };

  # Force qt to mimic configured gtk theme
  qt = {
    enable = true;
		style.name = "kvantum";
    platformTheme.name = "kvantum";
  };


}
