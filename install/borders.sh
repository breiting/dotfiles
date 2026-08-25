#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/install/lib/ui.sh"

[[ "$(uname -s)" == "Darwin" ]] || exit 0

ui_step "Active window border"

if ! command -v borders >/dev/null 2>&1; then
    ui_warn "borders is not installed. Run the Homebrew package step first."
    exit 0
fi

# The service is user-scoped. Starting it here makes the border survive login
# without requiring Hammerspoon or AeroSpace to own the process.
if brew services list | awk '$1 == "borders" && $2 == "started" { found=1 } END { exit !found }'; then
    ui_success "JankyBorders service is already running."
else
    if ui_confirm "Start JankyBorders automatically for this user?"; then
        brew services start borders
        ui_success "JankyBorders service started."
    else
        ui_info "JankyBorders service start skipped."
    fi
fi
