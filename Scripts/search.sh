#!/bin/bash

 # query=$(rofi -dmenu -p -theme ~/.config/rofi/launchers/type-3/search.rasi )
 # if [ -n "$query" ]; then
 #     zen-browser --new-window "https://duckduckgo.com/?t=ffab&q=$(echo $query | sed 's/ /+/g')"
 # fi

 #=====================================================================================================
query=$(rofi -dmenu -p -theme ~/.config/rofi/launchers/type-3/search.rasi)

if [ -n "$query" ]; then
    # Eğer input bir URL ise doğrudan aç
    if [[ "$query" =~ ^(https?://|www\.) || "$query" =~ \.([a-z]{2,})$ ]]; then
        zen-browser --new-window "$query"
    else
        # Değilse arama motoruna yönlendir
        zen-browser --new-window "https://duckduckgo.com/?t=ffab&q=$(echo $query | sed 's/ /+/g')"
    fi
fi
