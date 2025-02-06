#!/usr/bin/env bash

dir="$HOME/.config/rofi/launchers/type-3"
theme='style-5-screenshot'

CHOICE=$(echo -e "Manuel Area Selection\nWindow Selection\nAll Desktop" | rofi \
    -dmenu \
    -i \
    -theme ${dir}/${theme}.rasi \
    -p "select screenshot")

case $CHOICE in
    "Manuel Area Selection")
        FILE=~/Pictures/Screenshots/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png
        grim -g "$(slurp)" "$FILE"
        wl-copy < "$FILE" 
        cliphist store < "$FILE" 
        # notify-send "Screen Captured" "Window image copied to clipboard."
        notify-send "Screen Captured" "Window image copied to clipboard." --icon="$FILE"
        ;;
    "Window Selection")
        WINDOWS=$(hyprctl clients -j | jq -r '.[] | "\(.address) \(.class) - \(.title)"')

        SELECTED=$(echo "$WINDOWS" | rofi \
            -dmenu \
            -i \
            -theme ${dir}/${theme}.rasi \
            -p "Choose Window")
        
        # Seçilen adresi al
        WIN=$(echo "$SELECTED" | awk '{print $1}')

        if [ -n "$WIN" ]; then
            sleep 0.8 
            GEOMETRY=$(hyprctl clients -j | jq -r ".[] | select(.address==\"$WIN\") | \"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"")
            FILE=~/Pictures/Screenshots/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png
            grim -g "$GEOMETRY" "$FILE"
            wl-copy < "$FILE" 
            cliphist store < "$FILE" 
            # notify-send "Screen Captured" "Window image copied to clipboard."
            notify-send "Screen Captured" "Window image copied to clipboard." --icon="$FILE"
        else
            notify-send "Error" "Window selection failed"
        fi
        ;;
    "All Desktop")

        MONITOR=$(hyprctl monitors | awk '/Monitor/ {print $2}' | rofi \
            -dmenu \
            -i \
            -theme ${dir}/${theme}.rasi \
            -p "Choose Monitor")

        # Monitör seçimi yapılmadıysa işlemi iptal et
        if [ -z "$MONITOR" ]; then
            notify-send "Screenshot not taken" "No monitor was selected."
            exit 1
        fi

        sleep 0.8 

        FILE=~/Pictures/Screenshots/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png
        grim -o "$MONITOR" "$FILE"
        wl-copy < "$FILE" 
        cliphist store < "$FILE" 
        # notify-send "Screen Captured" "The screenshot of monitor $MONITOR was copied to the clipboard."
        notify-send "Screen Captured" "The screenshot of monitor $MONITOR was copied to the clipboard." --icon="$FILE"
        ;;
    *)
        notify-send "Screenshot not taken" "No elections were held or canceled"
        ;;
esac

