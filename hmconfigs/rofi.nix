{
  pkgs,
  config,
  ...
}: let
  # Thanks varun!
  powerMenuScript = name: rofiPkg:
    pkgs.writeShellScriptBin name ''
      MENU="$(echo "Lock|Suspend|Logout|Reboot|Shutdown" | ${rofiPkg}/bin/rofi -sep "|" -dmenu -i -p '󰐥' -lines 5 -theme-str 'inputbar { enabled: false; }' )"
      case "$MENU" in
        *Lock) xflock4;;
        *Suspend) playerctl pause & amixer set Master mute & systemctl suspend;;
        *Logout) xfce4-session-logout --logout;;
        *Reboot) systemctl reboot ;;
        *Shutdown) systemctl -i poweroff
      esac
    '';
in {
  home.packages = [
    (powerMenuScript "rofi-power-menu" pkgs.rofi)
  ];
  home.file = {
    ".config/rofi/config.rasi".text = ''
      * {
            background-transparent: rgba(15, 15, 20, 0.85);
            background-solid:       #0f0f14;
            foreground:             #d0d0d0;
            selected:               #3b3b3b;
            selected-foreground:    #ffffff;

            border:                 rgba(58, 58, 66, 0.8);
            border-highlight:       #3b3b3b;
            separatorcolor:         rgba(58, 58, 66, 0.8);
            scrollbar:              rgba(58, 58, 66, 0.8);
            urgent:                 #c23939;

            background-color: transparent;
            text-color: @foreground;
        }

        prompt {
            str: "";
            padding: 0;
            text-color: @foreground;
            background-color: transparent;
        }

        configuration {
            drun {
                display-name: "";
            }
        }

        window {
            background-color: @background-transparent;
            border: 1px;
            border-color: @border;
            border-radius: 0px;
            padding: 10;
            width: 35%;
            transparency: "real";
            fullscreen: false;
        }

        mainbox {
            border: 0;
            padding: 0;
            background-color: transparent;
        }

        message {
            border: 1px 0 0 0;
            border-color: @separatorcolor;
            padding: 8px;
            background-color: transparent;
        }

        textbox {
            text-color: @foreground;
            background-color: transparent;
        }
        textbox-prompt-colon {
            content: "";
        }

        listview {
            border: 1px 0 0 0;
            padding: 8px 0 0 0;
            border-color: @separatorcolor;
            spacing: 2px;
            scrollbar: true;
            background-color: transparent;
        }

        element {
            border: 0;
            padding: 8px;
            background-color: transparent;
        }

        element-text {
            background-color: transparent;
            text-color: inherit;
        }

        /* Normal state */
        element.normal.normal {
            background-color: transparent;
            text-color: @foreground;
        }

        /* Selected state */
        element.selected.normal {
            background-color: @selected;
            text-color: @selected-foreground;
        }

        /* Alternate (odd/even) items */
        element.alternate.normal {
            background-color: transparent;
            text-color: @foreground;
        }

        scrollbar {
            width: 4px;
            border: 0;
            handle-color: @scrollbar;
            handle-width: 4px;
            padding: 0;
            background-color: transparent;
        }

        sidebar {
            border: 0px;
            border-color: @separatorcolor;
            background-color: transparent;
        }

        inputbar {
          children: [overlay, entry];
      		padding: 8px;
      		background-color: rgba(15, 15, 20, 0.9);
      		border: 1px;
      		border-color: #000000;
        }

        entry {
            placeholder: "GET TO WORK";
            spacing: 0;
            text-color: @foreground;
            background-color: transparent;
        }

        case-indicator {
            enabled: false;
            spacing: 0;
            text-color: @foreground;
            background-color: transparent;
        }

        button {
            spacing: 0;
            text-color: @foreground;
            background-color: transparent;
        }

        button.selected {
            background-color: @selected;
            text-color: @selected-foreground;
        }

    '';
  };
}
