#!/usr/bin/env bash
set -u

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar"
STATE_FILE="$STATE_DIR/network"
mkdir -p "$STATE_DIR"

interface="$(
    route -n get default 2>/dev/null \
        | awk '/interface:/{print $2; exit}'
)"

if [[ -z "$interface" ]]; then
    sketchybar --set "$NAME" icon="󰖪" icon.color=0xfff38ba8 label="offline"
    rm -f "$STATE_FILE"
    exit 0
fi

read -r rx tx < <(
    netstat -ibn 2>/dev/null \
        | awk -v iface="$interface" '
            $1 == iface && $7 ~ /^[0-9]+$/ && $10 ~ /^[0-9]+$/ {
                rx += $7
                tx += $10
            }
            END { print rx+0, tx+0 }
        '
)

now="$(date +%s)"

prev_time=0
prev_rx=0
prev_tx=0

if [[ -f "$STATE_FILE" ]]; then
    read -r prev_time prev_rx prev_tx < "$STATE_FILE" || true
fi

printf '%s %s %s\n' "$now" "$rx" "$tx" > "$STATE_FILE"

format_rate() {
    local bytes="$1"

    if (( bytes >= 1048576 )); then
        awk -v b="$bytes" 'BEGIN { printf "%.1fM", b / 1048576 }'
    elif (( bytes >= 1024 )); then
        awk -v b="$bytes" 'BEGIN { printf "%.0fK", b / 1024 }'
    else
        printf '%dB' "$bytes"
    fi
}

if (( prev_time <= 0 || now <= prev_time || rx < prev_rx || tx < prev_tx )); then
    down="0B"
    up="0B"
else
    elapsed=$((now - prev_time))
    down_bytes=$(((rx - prev_rx) / elapsed))
    up_bytes=$(((tx - prev_tx) / elapsed))

    down="$(format_rate "$down_bytes")"
    up="$(format_rate "$up_bytes")"
fi

sketchybar --set "$NAME" \
    icon="" \
    icon.color=0xffa6e3a1 \
    label="↓${down} ↑${up}"
