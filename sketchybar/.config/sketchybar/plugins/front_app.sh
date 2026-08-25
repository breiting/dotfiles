#!/usr/bin/env bash
set -u

if [[ -n "${INFO:-}" ]]; then
    app="$INFO"
else
    app="$(
        aerospace list-windows --focused \
            --format '%{app-name}' 2>/dev/null \
            | head -n 1
    )"
fi

sketchybar --set "$NAME" label="${app:-Desktop}"
