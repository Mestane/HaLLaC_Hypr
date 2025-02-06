#!/usr/bin/env bash
#exec,cliphist list | rofi -dmenu | cliphist decode | wl-copy --type text/plain
#| cliphist decode | wl-copy --type text/plain

# dir="$HOME/.config/rofi/launchers/type-3"
# theme='style-5'
dir="$HOME/.config/rofi/launchers/type-3"
theme='style-5-new'

# cliphist list | rofi \
#     -dmenu \
#     -i -theme ${dir}/${theme}.rasi \
#     | cliphist decode | wl-copy


cliphist list | rofi -modi clipboard:~/.config/rofi/launchers/type-3/cliphist_rofi_img.sh -show clipboard -show-icons \
    -i -theme ${dir}/${theme}.rasi 
#

# cliphist list | rofi -dmenu -show-icons \
#     -i -theme ${dir}/${theme}.rasi | cliphist delete

# cliphist list | rofi -modi "clipboard:~/.config/rofi/launchers/type-3/cliphist_rofi_img.sh" \
#     -show clipboard -show-icons -i -theme "${dir}/${theme}.rasi" \
#     -kb-remove-entry "Delete" -run-command "cliphist delete"

