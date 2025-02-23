#!/usr/bin/env bash

ACTIVE_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')

STATUS=$(screen_record.sh status)

if [[ "$STATUS" == "recording" ]]; then
    screen_record.sh stop
    # notify-send "🎥 Screen Recording Stopped"
else
    screen_record.sh start "$ACTIVE_MONITOR"
    # notify-send "🎥 Screen Recording Started on $ACTIVE_MONITOR"
fi
