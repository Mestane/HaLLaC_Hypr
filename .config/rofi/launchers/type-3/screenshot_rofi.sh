#!/usr/bin/env bash

# Tema ve dizin tanımları
dir="$HOME/.config/rofi/launchers/type-3"
theme='style-5-kill'

# Kullanıcı seçimini sağlayacak seçenekler
CHOICE=$(echo -e "Manuel Area Selection\nWindow Selection\nAll Desktop" | rofi \
    -dmenu \
    -i \
    -theme ${dir}/${theme}.rasi \
    -p "Choose Screenshot")

case $CHOICE in
    "Manuel Area Selection")
        # sleep 0.5 # Rofi kapanmadan işlem yapmaması için kısa bekleme
        grim -g "$(slurp)" ~/Pictures/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png
        ;;
    "Window Selection")
        # Pencere listesi oluştur
        WINDOWS=$(hyprctl clients -j | jq -r '.[] | "\(.address) \(.class) - \(.title)"')

        # Kullanıcıya pencere seçimi yaptır
        SELECTED=$(echo "$WINDOWS" cliphist list | rofi \
            -dmenu \
            -i \
            -theme ${dir}/${theme}.rasi \
            -p "Select Window") \
            | cliphist decode | wl-copy --type image

        # Seçilen adresi al
        WIN=$(echo "$SELECTED" | awk '{print $1}')

        if [ -n "$WIN" ]; then
            sleep 0.7 # Rofi'nin kapanmasını beklemek için kısa bir gecikme
            GEOMETRY=$(hyprctl clients -j | jq -r ".[] | select(.address==\"$WIN\") | \"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"")
            grim -g "$GEOMETRY" ~/Pictures/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png
        else
            notify-send "Error" "Failed window selection"
        fi
        ;;
    "All Desktop")
        sleep 0.7 # Rofi kapanmadan işlem yapmaması için kısa bekleme
        grim ~/Pictures/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png
        ;;
    *)
        notify-send "Window selection failed" "Elections were not held or were canceled"
        ;;
esac

