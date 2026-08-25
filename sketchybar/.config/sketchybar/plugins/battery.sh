#!/usr/bin/env bash
set -u

info="$(pmset -g batt)"
percent="$(printf '%s\n' "$info" | grep -Eo '[0-9]+%' | head -n 1 | tr -d '%')"

if [[ -z "$percent" ]]; then
    sketchybar --set "$NAME" icon="" label="?"
    exit 0
fi

if printf '%s\n' "$info" | grep -q "AC Power"; then
    icon=""
elif (( percent >= 80 )); then
    icon=""
elif (( percent >= 60 )); then
    icon=""
elif (( percent >= 40 )); then
    icon=""
elif (( percent >= 20 )); then
    icon=""
else
    icon=""
fi

color=0xfff9e2af
(( percent <= 15 )) && color=0xfff38ba8

sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="${percent}%"
