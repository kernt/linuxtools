#!/bin/bash

notify-send -t 8000 -i /usr/share/icons/gnome/32x32/status/info.png " " "`shuf -n1 /home/$USER/.gnome2/nautilus-scripts/My_Scripts/Jokes/Fortune-Cookie-Quotes/.fortune-cookie-quotes.txt`"
