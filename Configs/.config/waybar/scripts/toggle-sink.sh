#!/bin/bash

current_sink=$(pactl info | grep "Default Sink:" | awk '{print $3}')
if [ "$current_sink" = "alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo" ]; then
    pactl set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo
else
    pactl set-default-sink alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo
fi

