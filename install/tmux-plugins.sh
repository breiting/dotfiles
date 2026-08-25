#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=install/lib/ui.sh
source "$ROOT_DIR/install/lib/ui.sh"

TMUX_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
TPM_DIR="$TMUX_CONFIG_DIR/plugins/tpm"

ui_step "tmux plugins"

if ! command -v git >/dev/null 2>&1; then
    ui_warn "Git is not available. tmux plugin installation is skipped."
    exit 0
fi

if ! command -v tmux >/dev/null 2>&1; then
    ui_warn "tmux is not available. tmux plugin installation is skipped."
    exit 0
fi

if [[ ! -f "$TMUX_CONFIG_DIR/tmux.conf" ]]; then
    ui_warn "tmux configuration is not active yet. Plugin installation is skipped."
    exit 0
fi

if [[ ! -d "$TPM_DIR/.git" ]]; then
    ui_info "TPM is not installed."
    if ! ui_confirm "Install tmux Plugin Manager (TPM)?"; then
        ui_warn "TPM installation skipped."
        exit 0
    fi

    mkdir -p "$(dirname "$TPM_DIR")"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ui_success "TPM installed."
else
    ui_success "TPM is already installed."
fi

# TPM reads the plugin declarations from ~/.config/tmux/tmux.conf and installs
# only plugins that are not already present.
if "$TPM_DIR/bin/install_plugins"; then
    ui_success "tmux plugins are installed."
else
    ui_fail "tmux plugin installation failed."
    exit 1
fi
