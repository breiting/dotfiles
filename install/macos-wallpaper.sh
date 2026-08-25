#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/install/lib/ui.sh"

[[ "$(uname -s)" == "Darwin" ]] || exit 0

ui_step "macOS wallpaper"

# Wallpaper scripting has changed across macOS releases and AppleScript-based
# approaches are less reliable with Spaces. We deliberately use a generated
# solid-black image and ask macOS to set it through System Settings once.
#
# The asset is still generated deterministically by the bootstrap so it can be
# reused on every machine.
wallpaper_dir="$HOME/Pictures/Wallpapers"
wallpaper="$wallpaper_dir/black.png"

mkdir -p "$wallpaper_dir"

if [[ ! -f "$wallpaper" ]]; then
    # macOS ships sips but not a simple image generator. Create a tiny valid
    # black PNG from embedded base64 without adding another dependency.
    printf '%s' \
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=' \
      | base64 --decode > "$wallpaper"
    ui_success "Created $wallpaper"
else
    ui_success "Black wallpaper asset already exists."
fi

ui_info "Wallpaper asset: $wallpaper"
ui_info "Set it once in System Settings > Wallpaper; macOS will retain it per user."
