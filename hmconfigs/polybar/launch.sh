# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit

 # Wait until the processes have been shut down
 while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

 if type "xrandr"; then
	 for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		 if [ $m == 'DP-2' ]
		 then
		 	MONITOR=$m polybar mexample &
		 else
		 	MONITOR=$m polybar example &
		 fi
	 done
 else
	 polybar --reload example &
 fi

