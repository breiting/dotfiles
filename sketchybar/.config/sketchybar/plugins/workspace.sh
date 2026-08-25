#!/usr/bin/env bash
set -u

sid="$1"
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null | head -n 1)}"

if [[ "$sid" == "$focused" ]]; then
    sketchybar --set "$NAME" \
        background.color=0xff444444 \
        label.color=0xffffffff
else
    sketchybar --set "$NAME" \
        background.color=0xff222222 \
        label.color=0xff888888
fi
