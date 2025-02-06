#!/bin/bash

# Birinci monitör için Waybar
WAYLAND_DISPLAY=:0 MONITOR=waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &

# İkinci monitör için Waybar
WAYLAND_DISPLAY=:0 MONITOR=waybar -c ~/.config/waybar/second_monitor.jsonc -s ~/.config/waybar/style.css &
