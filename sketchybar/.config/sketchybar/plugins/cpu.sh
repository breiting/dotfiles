#!/usr/bin/env bash
set -u

cpu="$(
    ps -A -o %cpu= \
        | awk '{sum += $1} END {printf "%.0f", sum}'
)"

cores="$(sysctl -n hw.logicalcpu 2>/dev/null || printf '1')"
if [[ "$cores" -gt 0 ]]; then
    cpu=$(( cpu / cores ))
fi

(( cpu > 100 )) && cpu=100
sketchybar --set "$NAME" label="${cpu}%"
