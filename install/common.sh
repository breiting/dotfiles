#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=install/lib/ui.sh
source "$ROOT_DIR/install/lib/ui.sh"
# shellcheck source=install/lib/stow.sh
source "$ROOT_DIR/install/lib/stow.sh"

ui_step "Common setup"

if ! command -v stow >/dev/null 2>&1; then
    ui_warn "GNU Stow is not available. Dotfile activation is skipped."
    exit 0
fi

# Dotfile packages are introduced deliberately, one at a time.
stow_package git
stow_package zsh
stow_package tmux

"$ROOT_DIR/install/tmux-plugins.sh"
"$ROOT_DIR/install/neovim.sh"
