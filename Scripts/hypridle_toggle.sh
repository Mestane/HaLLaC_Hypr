#!/bin/bash
if pidof hypridle > /dev/null; then
    pkill hypridle
else
   hypridle &
fi

