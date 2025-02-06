#!/bin/bash
fullscreen=$(hyprctl activewindow | grep "fullscreen" | awk '{print $2}')
if [[ "$fullscreen" -gt 0 ]]; then
    echo ""  # Burada istediğiniz tam ekran simgesini kullanabilirsiniz
else
    echo ""  # Eğer tam ekran değilse, hiçbir şey gösterme
fi
