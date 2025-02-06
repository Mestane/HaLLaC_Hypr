#!/bin/bash

# temp=$(sensors | grep 'Package id 0:' | awk '{print $4}' | tr -d '+')
# echo -e "{\"text\":\" $temp\",\"tooltip\":\"CPU Temperature: $temp\"}"

# temp=$(sensors | grep 'Package id 0:' | awk '{print $4}' | tr -d '+°C')
# echo $temp

temp=$(sensors | grep 'Package id 0:' | awk '{print $4}' | tr -d '+°C')
temp=${temp%.*} # Noktadan sonrasını siler
echo $temp

