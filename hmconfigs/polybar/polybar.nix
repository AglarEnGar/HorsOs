{
  pkgs,
  config,
  ...
}: {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      iwSupport = true;
      pulseSupport = true;
      githubSupport = true;
    };
    extraConfig = ''
       ;==========================================================
       ;
       ;
       ;   ██████╗  ██████╗ ██╗  ██╗   ██╗██████╗  █████╗ ██████╗
       ;   ██╔══██╗██╔═══██╗██║  ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗
       ;   ██████╔╝██║   ██║██║   ╚████╔╝ ██████╔╝███████║██████╔╝
       ;   ██╔═══╝ ██║   ██║██║    ╚██╔╝  ██╔══██╗██╔══██║██╔══██╗
       ;   ██║     ╚██████╔╝███████╗██║   ██████╔╝██║  ██║██║  ██║
       ;   ╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
       ;
       ;
       ;   To learn more about how to configure Polybar
       ;   go to https://github.com/polybar/polybar
       ;
       ;   The README contains a lot of information
       ;
       ;==========================================================

       [colors]
       background = 000000
       background-alt = #636363
       foreground = #ffffff
       primary = #ffffff
       secondary = #8ABEB7
       alert = #A54242
       disabled = #707880

       # Main bar
       [bar/mexample]
       width = 100%
       height = 30pt
       radius = 0
       override-redirect = false

       bottom = false
       left = false
       right = false
       top = true

       ; dpi = 96

       background = ''${colors.background}
       foreground = ''${colors.foreground}

       line-size = 1pt

       border-size = 3pt
       border-color = #00000000

       padding-left = 0
       padding-right = 1

       module-margin = 1

       separator = -
       separator-foreground = ''${colors.disabled}

       font-0 = monospace;2

       # left right and CENTER
       modules-left = i3ws
       modules-center = date
       modules-right = systray battery
       cursor-click = pointer
       cursor-scroll = ns-resize

       enable-ipc = true
       wm-restack = i3

       # side bars
       [bar/example]
       width = 100%
       height = 30pt
       radius = 0
       override-redirect = false

       bottom = false
       left = false
       right = false
       top = true

       ; dpi = 96

       background = ''${colors.background}
       foreground = ''${colors.foreground}

       line-size = 1pt

       border-size = 3pt
       border-color = #00000000

       padding-left = 0
       padding-right = 1

       module-margin = 1

       separator = -
       separator-foreground = ''${colors.disabled}

       font-0 = monospace;2

       # MODULE PLACEMENT
       modules-left = i3ws
       modules-center = date
       modules-right = pulseaudio
       cursor-click = pointer
       cursor-scroll = ns-resize

       enable-ipc = true
       wm-restack = i3


       ; This module is not active by default (to enable it, add it to one of the
       ; modules-* list above).
       ; Please note that only a single tray can exist at any time. If you launch
       ; multiple bars with this module, only a single one will show it, the others
       ; will produce a warning. Which bar gets the module is timing dependent and can
       ; be quite random.
       ; For more information, see the documentation page for this module:
       ; https://polybar.readthedocs.io/en/stable/user/modules/tray.html

       [module/systray]
       type = internal/tray

       format-margin = 8pt
       tray-spacing = 12pt

       [module/i3ws]
       type = internal/i3
       pin-workspaces = true
       index-sort = true

       ws-icon-0 = 1;1
       ws-icon-1 = 2;2
       ws-icon-2 = 3;3
       ws-icon-3 = 4;4
       ws-icon-4 = 5;5
       ws-icon-5 = 6;6
       ws-icon-6 = 7;7
       ws-icon-7 = 8;8
       ws-icon-8 = 9;9
       ws-icon-9 = 10;10

       label-focused = %icon%
       label-focused-background = ''${colors.background-alt}
       label-focused-underline= ''${colors.primary}
       label-focused-padding = 1

       label-visible = %icon%
       label-visible-padding = 1

       label-urgent = %icon%
       label-urgent-background = ''${colors.alert}
       label-urgent-padding = 1

      # label-separator = |
      # label-separator-padding = 1
      # label-separator-foreground = #ffffff

       label-unfocused = %icon%
       label-unfocused-foreground = ''${colors.disabled}
       label-unfocused-padding = 1

       [module/xworkspaces]
       type = internal/xworkspaces
       pin-workspaces = true

       label-active = %name%
       label-active-background = ''${colors.background-alt}
       label-active-underline= ''${colors.primary}
       label-active-padding = 1

       label-occupied = %name%
       label-occupied-padding = 1

       label-urgent = %name%
       label-urgent-background = ''${colors.alert}
       label-urgent-padding = 1

       label-empty = %name%
       label-empty-foreground = ''${colors.disabled}
       label-empty-padding = 1

       [module/xwindow]
       type = internal/xwindow
       label = %title:0:60:...%

       [module/filesystem]
       type = internal/fs
       interval = 25

       mount-0 = /

       label-mounted = %{F#F0C674}%mountpoint%%{F-} %percentage_used%%

       label-unmounted = %mountpoint% not mounted
       label-unmounted-foreground = ''${colors.disabled}

			 [module/battery]
			 type = internal/battery

			 ; This is useful in case the battery never reports 100% charge
			 ; Default: 100
			 full-at = 99

			 ; format-low once this charge percentage is reached
			 ; Default: 10
			 ; New in version 3.6.0
			 low-at = 5

			 ; Use the following command to list batteries and adapters:
			 ; $ ls -1 /sys/class/power_supply/
			 battery = BAT1
			 adapter = ADP1

			 ; If an inotify event haven't been reported in this many
			 ; seconds, manually poll for new values.
			 ;
			 ; Needed as a fallback for systems that don't report events
			 ; on sysfs/procfs.
			 ;
			 ; Disable polling by setting the interval to 0.
			 ;
			 ; Default: 5
			 poll-interval = 5
			 ; see "man date" for details on how to format the time string
			 ; NOTE: if you want to use syntax tags here you need to use %%{...}
			 ; Default: %H:%M:%S
			 ;time-format = %H:%M

			 ; Available tags:
			 ;   <label-charging> (default)
			 ;   <bar-capacity>
			 ;   <ramp-capacity>
			 ;   <animation-charging>
			 format-charging = <animation-charging> <label-charging>

			 ; Available tags:
			 ;   <label-discharging> (default)
			 ;   <bar-capacity>
			 ;   <ramp-capacity>
			 ;   <animation-discharging>
			 format-discharging = <ramp-capacity> <label-discharging>

			 ; Available tags:
			 ;   <label-full> (default)
			 ;   <bar-capacity>
			 ;   <ramp-capacity>
			 ;format-full = <ramp-capacity> <label-full>

			 ; Format used when battery level drops to low-at
			 ; If not defined, format-discharging is used instead.
			 ; Available tags:
			 ;   <label-low>
			 ;   <animation-low>
			 ;   <bar-capacity>
			 ;   <ramp-capacity>
			 ; New in version 3.6.0
			 ;format-low = <label-low> <animation-low>

			 ; Available tokens:
			 ;   %percentage% (default) - is set to 100 if full-at is reached
			 ;   %percentage_raw%
			 ;   %time%
			 ;   %consumption% (shows current charge rate in watts)
			 label-charging = %percentage%%

			 ; Available tokens:
			 ;   %percentage% (default) - is set to 100 if full-at is reached
			 ;   %percentage_raw%
			 ;   %time%
			 ;   %consumption% (shows current discharge rate in watts)
			 label-discharging = %percentage%%

			 ; Available tokens:
			 ;   %percentage% (default) - is set to 100 if full-at is reached
			 ;   %percentage_raw%
			 label-full = Fully charged

			 ; Available tokens:
			 ;   %percentage% (default) - is set to 100 if full-at is reached
			 ;   %percentage_raw%
			 ;   %time%
			 ;   %consumption% (shows current discharge rate in watts)
			 ; New in version 3.6.0
			 label-low = BATTERY LOW

			 ; Only applies if <ramp-capacity> is used
			 ramp-capacity-0 = 
			 ramp-capacity-1 = 
			 ramp-capacity-2 = 
			 ramp-capacity-3 = 
			 ramp-capacity-4 = 

			 ; Only applies if <bar-capacity> is used
			 bar-capacity-width = 10

			 ; Only applies if <animation-charging> is used
			 animation-charging-0 = 
			 animation-charging-1 = 
			 animation-charging-2 = 
			 animation-charging-3 = 
			 animation-charging-4 = 
			 ; Framerate in milliseconds
			 animation-charging-framerate = 750

			 ; Only applies if <animation-discharging> is used
			 animation-discharging-0 = 
			 animation-discharging-1 = 
			 animation-discharging-2 = 
			 animation-discharging-3 = 
			 animation-discharging-4 = 
			 ; Framerate in milliseconds
			 animation-discharging-framerate = 500

			 ; Only applies if <animation-low> is used
			 ; New in version 3.6.0
			 animation-low-0 = !
			 animation-low-1 = 
			 animation-low-framerate = 200

       [module/pulseaudio]
       type = internal/pulseaudio

       format-volume-prefix = "VOL "
       format-volume-prefix-foreground = ''${colors.primary}
       format-volume = <label-volume>

       label-volume = %percentage%%

       label-muted = muted
       label-muted-foreground = ''${colors.disabled}

       [module/xkeyboard]
       type = internal/xkeyboard
       blacklist-0 = num lock

       label-layout = %layout%
       label-layout-foreground = ''${colors.primary}

       label-indicator-padding = 2
       label-indicator-margin = 1
       label-indicator-foreground = ''${colors.background}
       label-indicator-background = ''${colors.secondary}

       [module/memory]
       type = internal/memory
       interval = 2
       format-prefix = "RAM "
       format-prefix-foreground = ''${colors.primary}
       label = %percentage_used:2%%

       [module/cpu]
       type = internal/cpu
       interval = 2
       format-prefix = "CPU "
       format-prefix-foreground = ''${colors.primary}
       label = %percentage%%

       [network-base]
       type = internal/network
       interval = 5
       format-connected = <label-connected>
       format-disconnected = <label-disconnected>
       label-disconnected = %{F#F0C674}%ifname%%{F#707880} disconnected

       [module/wlan]
       inherit = network-base
       interface-type = wireless
       label-connected = %{F#F0C674}%ifname%%{F-} %essid% %local_ip%

       [module/eth]
       inherit = network-base
       interface-type = wired
       label-connected = %{F#F0C674}%ifname%%{F-} %local_ip%

       [module/date]
       type = internal/date
       interval = 1
       date = %Y-%m-%d %H:%M:%S
       label-foreground = ''${colors.primary}
       format = <label>
       label = "%{A1:eww open --toggle calendar:}%date%%{A}"

       [module/popup_trigger]
       type = custom/text
       content = "🐧"
       click-left = "polybar-msg cmd toggle control_popup"

       [settings]
       screenchange-reload = true
       pseudo-transparency = false

       ; vim:ft=dosini
    '';
    script = ''
      # stoopid thing dong work
      echo "help me man"
    '';
  };
}
