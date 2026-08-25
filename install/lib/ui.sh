#!/usr/bin/env bash

# Minimal terminal UI for bootstrap scripts.
# It intentionally has no dependencies beyond a POSIX-like terminal and Bash.

if [[ -t 1 && -z "${NO_COLOR:-}" && "${TERM:-}" != "dumb" ]]; then
    UI_BOLD='\033[1m'
    UI_DIM='\033[2m'
    UI_BLUE='\033[34m'
    UI_GREEN='\033[32m'
    UI_YELLOW='\033[33m'
    UI_RED='\033[31m'
    UI_RESET='\033[0m'
else
    UI_BOLD=''
    UI_DIM=''
    UI_BLUE=''
    UI_GREEN=''
    UI_YELLOW=''
    UI_RED=''
    UI_RESET=''
fi

ui_banner() {
    local title="$1"
    local subtitle="${2:-}"

    printf '\n%b%s%b\n' "$UI_BOLD" "$title" "$UI_RESET"
    if [[ -n "$subtitle" ]]; then
        printf '%b%s%b\n' "$UI_DIM" "$subtitle" "$UI_RESET"
    fi
    printf '%b%s%b\n\n' "$UI_DIM" '────────────────────────────────────────' "$UI_RESET"
}

ui_step() {
    printf '%b==>%b %b%s%b\n' "$UI_BLUE$UI_BOLD" "$UI_RESET" "$UI_BOLD" "$1" "$UI_RESET"
}

ui_info() {
    printf '%b  •%b %s\n' "$UI_DIM" "$UI_RESET" "$1"
}

ui_success() {
    printf '%b  ✓%b %s\n' "$UI_GREEN$UI_BOLD" "$UI_RESET" "$1"
}

ui_warn() {
    printf '%b  !%b %s\n' "$UI_YELLOW$UI_BOLD" "$UI_RESET" "$1"
}

ui_fail() {
    printf '%b  ✗%b %s\n' "$UI_RED$UI_BOLD" "$UI_RESET" "$1" >&2
}

ui_confirm() {
    local prompt="$1"
    local reply

    if [[ ! -t 0 ]]; then
        return 1
    fi

    printf '%b  ?%b %s [y/N] ' "$UI_YELLOW$UI_BOLD" "$UI_RESET" "$prompt"
    read -r reply
    [[ "$reply" =~ ^[Yy]([Ee][Ss])?$ ]]
}
