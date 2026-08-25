#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/install/lib/ui.sh"

[[ "$(uname -s)" == "Darwin" ]] || exit 0

config="${XDG_CONFIG_HOME:-$HOME/.config}/aerospace/aerospace.toml"

ui_step "AeroSpace / SketchyBar integration"

if [[ ! -f "$config" ]]; then
    ui_warn "AeroSpace config not found: $config"
    exit 0
fi

if grep -q '^exec-on-workspace-change[[:space:]]*=' "$config"; then
    ui_success "AeroSpace workspace-change hook already exists."
    exit 0
fi

hook="exec-on-workspace-change = ['/bin/bash', '-c', 'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=\$AEROSPACE_FOCUSED_WORKSPACE']"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

# Insert the top-level key before the first TOML table. Appending it at the end
# could accidentally place it inside the last [[on-window-detected]] table.
awk -v hook="$hook" '
    BEGIN { inserted = 0 }
    !inserted && $0 ~ /^\[/ {
        print ""
        print "# Notify SketchyBar immediately when the AeroSpace workspace changes."
        print hook
        print ""
        inserted = 1
    }
    { print }
    END {
        if (!inserted) {
            print ""
            print "# Notify SketchyBar immediately when the AeroSpace workspace changes."
            print hook
        }
    }
' "$config" > "$tmp"

mv "$tmp" "$config"
trap - EXIT

ui_success "Added AeroSpace workspace-change hook."
ui_info "Reload AeroSpace after bootstrap if it was already running."
