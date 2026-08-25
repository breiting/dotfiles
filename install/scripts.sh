#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/install/lib/ui.sh"

BIN_DIR="$HOME/.local/bin"

common_scripts=(
    dn
    prettier-safe-md
    stock-rename
)

linux_scripts=(
    monitor-hyprland
    monitor-sway
    polish-text
    rbwmenu
    start-sway
    timer
    v
)

macos_scripts=(
    zettelsync
)

link_script() {
    local platform="$1"
    local name="$2"
    local source="$ROOT_DIR/scripts/$platform/$name"
    local target="$BIN_DIR/$name"
    local current=""

    if [[ ! -f "$source" ]]; then
        ui_fail "Script source not found: $source"
        return 1
    fi

    if [[ ! -x "$source" ]]; then
        ui_fail "Script is not executable: $source"
        return 1
    fi

    if [[ -L "$target" ]]; then
        current="$(readlink "$target")"

        if [[ "$current" == "$source" ]]; then
            ui_success "$name"
            return 0
        fi

        if [[ ! -e "$target" && "$current" == */scripts/"$platform"/"$name" ]]; then
            ln -sfn "$source" "$target"
            ui_success "$name (relinked)"
            return 0
        fi

        ui_warn "$name skipped: existing symlink points elsewhere"
        ui_info "$target -> $current"
        return 0
    fi

    if [[ -e "$target" ]]; then
        ui_warn "$name skipped: existing file is not managed by this repository"
        ui_info "$target"
        return 0
    fi

    ln -s "$source" "$target"
    ui_success "$name"
}

link_group() {
    local platform="$1"
    shift
    local script

    for script in "$@"; do
        link_script "$platform" "$script"
    done
}

ui_step "Personal scripts"
mkdir -p "$BIN_DIR"

link_group common "${common_scripts[@]}"

case "$(uname -s)" in
    Linux)
        (( ${#linux_scripts[@]} > 0 )) && link_group linux "${linux_scripts[@]}"
        ;;
    Darwin)
        (( ${#macos_scripts[@]} > 0 )) && link_group macos "${macos_scripts[@]}"
        ;;
esac
