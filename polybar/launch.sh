#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
 killall -q polybar

echo "---" | tee -a /tmp/polybar.log # /tmp/polybar2.log
polybar bar 2>&1 | tee -a /tmp/polybar.log & disown
# polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown

echo "Bars launched..."
