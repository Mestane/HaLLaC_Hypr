#!/bin/bash
# playerctl --player=chromium metadata --format '{{ artist }} - {{ title }}'

status=$(playerctl --player=chromium status 2>/dev/null)

case "$status" in
    "Playing") icon="󰎆 " ;;   # Çalma ikonu
    "Paused") icon="󰏥 " ;;    # Duraklatma ikonu
    # "Stopped" | "") icon="󰙦 " ;;  # Durdurma ikonu
esac

muted=$(pactl list sinks | grep -A 10 'RUNNING' | grep 'Mute: yes')
if [[ -n "$muted" ]]; then
    icon="󰝟 "
fi

# Şarkı bilgisini al
song_info=$(playerctl --player=chromium metadata --format '{{ artist }} - {{ title }}' 2>/dev/null)

# Tek seferlik çıktıyı bas
echo "$icon $song_info"

