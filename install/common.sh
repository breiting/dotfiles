#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/install/lib/ui.sh"
source "$ROOT_DIR/install/lib/stow.sh"

ui_step "Common setup"

if ! command -v stow >/dev/null 2>&1; then
    ui_warn "GNU Stow is not available. Dotfile activation is skipped."
    exit 0
fi

stow_package git
stow_package zsh
stow_package tmux
stow_package lazygit
stow_package ghostty

"$ROOT_DIR/install/tmux-plugins.sh"
"$ROOT_DIR/install/neovim.sh"

stow_package nvim
"$ROOT_DIR/install/neovim-tools.sh"

case "$(uname -s)" in
    Darwin)
        stow_package aerospace
        stow_package borders
        stow_package sketchybar

        "$ROOT_DIR/install/aerospace-sketchybar.sh"
        "$ROOT_DIR/install/macos-defaults.sh"
        "$ROOT_DIR/install/borders.sh"
        "$ROOT_DIR/install/sketchybar.sh"
        ;;
    Linux)
        stow_package sway
        stow_package swaync
        stow_package waybar
        stow_package wireplumber
        stow_package wofi

        "$ROOT_DIR/install/sway-host.sh"
        ;;
esac

"$ROOT_DIR/install/scripts.sh"
