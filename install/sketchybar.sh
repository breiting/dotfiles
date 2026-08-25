#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/install/lib/ui.sh"

[[ "$(uname -s)" == "Darwin" ]] || exit 0

ui_step "SketchyBar"

if ! command -v sketchybar >/dev/null 2>&1; then
    ui_warn "SketchyBar is not installed. Run the Homebrew package step first."
    exit 0
fi

config="${XDG_CONFIG_HOME:-$HOME/.config}/sketchybar/sketchybarrc"
if [[ ! -x "$config" ]]; then
    ui_warn "SketchyBar config is missing or not executable: $config"
    exit 0
fi

if brew services list | awk '$1 == "sketchybar" && $2 == "started" { found=1 } END { exit !found }'; then
    sketchybar --reload
    ui_success "SketchyBar reloaded."
else
    if ui_confirm "Start SketchyBar automatically for this user?"; then
        brew services start sketchybar
        ui_success "SketchyBar service started."
    else
        ui_info "SketchyBar service start skipped."
    fi
fi
