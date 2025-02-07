#!/bin/bash

MONITOR="DP-3"

STATUS=$(hyprctl monitors | grep "$MONITOR")

if [ -z "$STATUS" ]; then
    hyprctl keyword monitor "$MONITOR",1920x1080@119.98,1920x0,1.0
    hyprctl keyword monitor "$MONITOR",transform,1
else
    hyprctl keyword monitor "$MONITOR",disable
fi

