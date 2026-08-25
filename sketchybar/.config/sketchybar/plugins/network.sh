#!/usr/bin/env bash
set -u

interface="$(
    route -n get default 2>/dev/null \
        | awk '/interface:/{print $2; exit}'
)"

if [[ -z "$interface" ]]; then
    sketchybar --set "$NAME" icon="󰖪" icon.color=0xfff38ba8 label="offline"
    exit 0
fi

ip="$(ipconfig getifaddr "$interface" 2>/dev/null || true)"

if [[ -z "$ip" ]]; then
    sketchybar --set "$NAME" icon="󰖪" icon.color=0xfff38ba8 label="offline"
else
    sketchybar --set "$NAME" icon="" icon.color=0xffa6e3a1 label="$interface"
fi
