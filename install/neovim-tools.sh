#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/install/lib/ui.sh"

ui_step "Neovim tools"

if ! command -v nvim >/dev/null 2>&1; then
    ui_warn "Neovim is not available. Mason tooling is skipped."
    exit 0
fi

if [[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.lua" ]]; then
    ui_warn "Neovim configuration is not active. Mason tooling is skipped."
    exit 0
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
    missing=()

    command -v tree-sitter >/dev/null 2>&1 || missing+=("tree-sitter-cli")
    command -v pyright-langserver >/dev/null 2>&1 || missing+=("pyright")

    if (( ${#missing[@]} > 0 )); then
        ui_warn "Required macOS workstation tools are missing:"
        for tool in "${missing[@]}"; do
            printf '      - %s\n' "$tool"
        done
        ui_info "Run the Homebrew package step and retry."
        exit 0
    fi
fi

if ! ui_confirm "Install or update the configured Mason tools?"; then
    ui_info "Mason tool installation skipped."
    exit 0
fi

ui_step "Preparing Neovim plugins"
nvim --headless "+Lazy! sync" +qa

ui_step "Installing configured Mason tools"
if nvim --headless "+MasonToolsInstallSync" +qa; then
    ui_success "Configured Mason tools are installed."
else
    ui_fail "Mason tool installation failed."
    ui_info "Open :Mason and :checkhealth in Neovim for details."
    exit 1
fi
