#!/usr/bin/env bash

source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Screenshot'
mesg="DIR: `xdg-user-dir PICTURES`/Screenshots"



if [[ "$theme" == *'type-1'* ]]; then
    list_col='1'
    list_row='5'
    win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
    list_col='1'
    list_row='5'
    win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
    list_col='1'
    list_row='5'
    win_width='520px'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
    list_col='5'
    list_row='1'
    win_width='670px'
fi

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
    option_1=" Capture Desktop"
    option_2=" Capture Area"
    option_3=" Capture Window"
    option_4=" Capture in 5s"
    option_5=" Capture in 10s"
else
    option_1=""
    option_2=""
    option_3=""
    option_4=""
    option_5=""
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
# geometry=`hyprctl monitors | jq -r '.monitors[0] | "\(.x),\(.y) \(.width)x\(.height)"'`
# geometry=$(hyprctl clients -j | jq -r ".[] | select(.address==\"$WIN\") | \"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"")
# 0000
time=`date +%Y-%m-%d-%H-%M-%S`
geometry=$(hyprctl clients -j | jq -r ".[] | select(.address==\"$WIN\") | \"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"")

dir="`xdg-user-dir PICTURES`/Screenshots"
# file="Screenshot_${time}_${geometry}.png"
file=~/Pictures/Screenshots/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png


if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
fi

# notify and view screenshot
# notify_view() {
#     # notify_cmd_shot='makoctl send --priority low "Screenshot copied to clipboard."'
#     # notify_cmd_shot='notify-send --urgency=low --expire-time=1000'
#     ${notify_cmd_shot}
#     imv ${dir}/"$file"
#     if [[ -e "$dir/$file" ]]; then
#         ${notify_cmd_shot} "Screenshot saved."
#     else
#         ${notify_cmd_shot} "Screenshot deleted."
#     fi
# }

notify_view() {
    notify_cmd='notify-send --urgency=low --expire-time=1000'
    if [[ -f "$file" ]]; then # Check if file exists *before* trying to view it
        $notify_cmd "Screenshot saved to: $file"
        imv "$file" & # Run imv in the background
    else
        $notify_cmd "Screenshot failed."
    fi
}

copy_shot () {
    # cat "$file" | wl-copy --type image/png
    # wl-copy < "$file" --type image/png # Redirect file content instead of using cat
    wl-copy < "$file"  # Redirect file content instead of using cat
}

# countdown function
countdown () {
    for sec in `seq $1 -1 1`; do
        # dunstify -t 1000 --replace=699 "Taking shot in: $sec"
        notify-send "Taking shot in: $sec" --expire-time=1000 --urgency=normal
        sleep 1
    done
}

# take shots

shotnow () {
    file="${dir}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
    cd "${dir}" && sleep 0.5 && grim "$file" && copy_shot
    notify_view
}

shot5 () {
    countdown '5'
    file="${dir}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
    sleep 1 && cd "${dir}" && grim "$file" && copy_shot
    notify_view
}

shot10 () {
    countdown '10'
    file="${dir}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
    sleep 1 && cd "${dir}" && grim "$file" && copy_shot
    notify_view
}

            # grim -g "$GEOMETRY" "$FILE"
            # wl-copy < "$FILE" 
            # cliphist store < "$FILE" 
            # notify-send "Screen Captured" "Window image copied to clipboard."

shotwin () {
    file="${dir}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
    # cd "${dir}" && grim -g "$(hyprctl clients -j | jq -r '.[] | select(.focused == true).at')" "$file" && copy_shot
    cd "${dir}" && grim -g "$geometry" "$file" && copy_shot
    notify_view
}

shotarea () {
    file="${dir}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
    cd "${dir}" && grim -g "$(slurp)" "$file" && copy_shot
    notify_view
}


# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        shotnow
    elif [[ "$1" == '--opt2' ]]; then
        shotarea
    elif [[ "$1" == '--opt3' ]]; then
        shotwin
    elif [[ "$1" == '--opt4' ]]; then
        shot5
    elif [[ "$1" == '--opt5' ]]; then
        shot10
    fi
}
# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
        run_cmd --opt1
        ;;
    $option_2)
        run_cmd --opt2
        ;;
    $option_3)
        run_cmd --opt3
        ;;
    $option_4)
        run_cmd --opt4
        ;;
    $option_5)
        run_cmd --opt5
        ;;
esac

