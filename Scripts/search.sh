#!/bin/bash

 # query=$(rofi -dmenu -p -theme ~/.config/rofi/launchers/type-3/search.rasi )
 # if [ -n "$query" ]; then
 #     zen-browser --new-window "https://duckduckgo.com/?t=ffab&q=$(echo $query | sed 's/ /+/g')"
 # fi

 #=====================================================================================================
query=$(rofi -dmenu -p -theme ~/.config/rofi/launchers/type-3/search.rasi)

if [ -n "$query" ]; then
    if [[ "$query" =~ ^(https?://|www\.) || "$query" =~ \.([a-z]{2,})$ ]]; then
        zen-browser --new-window "$query"
    else
        zen-browser --new-window "https://duckduckgo.com/?t=ffab&q=$(echo $query | sed 's/ /+/g')"
    fi
fi

