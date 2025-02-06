#!/bin/bash

updates=$(checkupdates 2>/dev/null)
if [[ -n "$updates" ]]; then
    echo "$updates" > /tmp/waybar-updates
    echo "$(echo "$updates" | wc -l)"
else
    echo "" > /tmp/waybar-updates
    echo "0"
fi

