#!/usr/bin/env bash
set -u

if [[ -n "${INFO:-}" ]]; then
    volume="${INFO%.*}"
else
    volume="$(
        osascript -e 'output volume of (get volume settings)' 2>/dev/null \
            || printf '0'
    )"
fi

muted="$(
    osascript -e 'output muted of (get volume settings)' 2>/dev/null \
        || printf 'false'
)"

if [[ "$muted" == "true" || "$volume" -eq 0 ]]; then
    sketchybar --set "$NAME" icon="󰖁" icon.color=0xfff38ba8 label="mute"
else
    sketchybar --set "$NAME" icon="" icon.color=0xffcdd6f4 label="${volume}%"
fi
