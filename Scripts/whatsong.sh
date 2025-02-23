#!/bin/bash
# playerctl --player=chromium metadata --format '{{ artist }} - {{ title }}'

status=$(playerctl --player=chromium status 2>/dev/null)

case "$status" in
    "Playing") icon="󰎆 " ;;   
    "Paused") icon="󰏥 " ;;    
    # "Stopped" | "") icon="󰙦 " ;;  
esac

muted=$(pactl list sinks | grep -A 10 'RUNNING' | grep 'Mute: yes')
if [[ -n "$muted" ]]; then
    icon="󰝟 "
fi

song_info=$(playerctl --player=chromium metadata --format '{{ artist }} - {{ title }}' 2>/dev/null)

echo "$icon $song_info"

