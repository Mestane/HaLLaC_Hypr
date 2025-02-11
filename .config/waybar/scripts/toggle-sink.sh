#!/bin/bash 

# PLEASE REPLACE THE INPUT DEVICES (WASHBASIN) WITH YOURS
sink1="alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo"
sink2="alsa_output.pci-0000_01_00.1.hdmi-stereo"
sink3="alsa_output.pci-0000_00_1f.3.analog-stereo"

available_sinks=$(pactl list short sinks | awk '{print $2}')

current_sink=$(pactl info | grep "Default Sink:" | awk '{print $3}')

sinks=()
for sink in "$sink1" "$sink2" "$sink3"; do
    if echo "$available_sinks" | grep -q "$sink"; then
        sinks+=("$sink")
    fi
done

if [ ${#sinks[@]} -eq 0 ]; then
    echo "Hata: Kullanılabilir ses çıkışı bulunamadı."
    exit 1
fi

current_index=-1
for i in "${!sinks[@]}"; do
    if [ "${sinks[$i]}" = "$current_sink" ]; then
        current_index=$i
        break
    fi
done

if [ "$current_index" -ge 0 ] && [ "$current_index" -lt $((${#sinks[@]} - 1)) ]; then
    next_index=$((current_index + 1))
else
    next_index=0
fi

pactl set-default-sink "${sinks[$next_index]}"
echo "Yeni varsayılan ses çıkışı: ${sinks[$next_index]}"

