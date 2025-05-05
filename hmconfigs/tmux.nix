{
  pkgs,
  config,
  ...
}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      sensible
      prefix-highlight
    ];

    extraConfig = ''
      # remap prefix from 'C-b' to 'C-a'
      			unbind C-b
      			set-option -g prefix C-a
      			bind-key C-a send-prefix

      # reload config file (change file location to your the tmux.conf you want to use)
      			bind r source-file /home/nickd/.config/tmux/tmux.conf

      # switch panes using Alt-arrow without prefix
      			bind -n M-Left select-pane -L
      			bind -n M-Right select-pane -R
      			bind -n M-Up select-pane -U
      			bind -n M-Down select-pane -D

      # switch panes using Alt-arrow without prefix
      			bind h select-pane -L
            unbind l
      			bind l select-pane -R
      			bind k select-pane -U
      			bind j select-pane -D

      # Options to make tmux more pleasant
      			set -g mouse on
      			set -g default-terminal "tmux-256color"

      # Configure the catppuccin plugin
      			set -g @catppuccin_flavor "macchiato" # latte, frappe, macchiato, or mocha
      			set -g @catppuccin_window_status_style "basic" # basic, rounded, slanted, custom, or none

      # Make the status line pretty and add some modules
      			set -g status-right-length 100
      			set -g status-left-length 100
      			set -g status-left ""
      			set -g status-right "#{E:@catppuccin_status_application}"
      			set -ag status-right "#{E:@catppuccin_status_session}"
      			set -ag status-right "#{E:@catppuccin_status_uptime}"
      			set -g pane-border-style fg=#6668ba
    '';
  };
}
