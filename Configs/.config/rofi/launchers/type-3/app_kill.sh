#!/usr/bin/env bash

# dir="$HOME/.config/rofi/launchers/type-3"
dir="$HOME/.config/rofi/launchers/type-3"
theme='style-10-kill'
# theme='style-5-kill'

# PPID'ye göre sıralanmış ps çıktısını al
ps -eo user,pid,ppid,%mem,%cpu,comm --sort=ppid | awk '{
    if (NR == 1) {
        printf "%-10s %-6s %-6s %-6s %-6s %s\n", "USER", "PID", "PPID", "MEM%", "CPU%", "COMMAND"
    } else {
        printf "%-10s %-6s %-6s %-6s %-6s %s\n", $1, $2, $3, $4, $5, $6
    }
}' | rofi \
    -dmenu \
    -i \
    -theme ${dir}/${theme}.rasi \
    | awk '{print $2}' | xargs -r kill -9

