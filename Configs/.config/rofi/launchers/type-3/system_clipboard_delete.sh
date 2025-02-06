#!/usr/bin/env bash
#exec,cliphist list | rofi -dmenu | cliphist decode | wl-copy --type text/plain
#| cliphist decode | wl-copy --type text/plain

# dir="$HOME/.config/rofi/launchers/type-3"
# theme='style-5'
dir="$HOME/.config/rofi/launchers/type-3"
theme='style-5-delete'


# cliphist list | rofi -dmenu -show-icons \
#     -i -theme ${dir}/${theme}.rasi | cliphist delete

cliphist list | rofi -dmenu -multi-select -ballot-selected-str " " -show-icons \
    -i -theme ${dir}/${theme}.rasi | cliphist delete

