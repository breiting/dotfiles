#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/install/lib/ui.sh"

ui_step "Yazi"

if command -v yazi >/dev/null 2>&1; then
    ui_success "Yazi is already installed: $(yazi --version | head -n 1)"
    exit 0
fi

case "$(uname -s)" in
    Darwin)
        # macOS ownership belongs to the Brewfile. If we get here, the package
        # step was skipped or failed.
        ui_warn "Yazi is missing. Install the macOS Brewfile and rerun bootstrap."
        ;;
    Linux)
        if [[ ! -r /etc/os-release ]] || ! grep -q '^ID=fedora$' /etc/os-release; then
            ui_warn "Automatic Yazi installation is only configured for Fedora."
            exit 0
        fi

        ui_info "Fedora does not ship Yazi in the standard Fedora 44 repositories."
        ui_info "Yazi's upstream documentation recommends the lihaohong/yazi COPR."

        if ! ui_confirm "Enable the Yazi COPR and install Yazi?"; then
            ui_info "Yazi installation skipped."
            exit 0
        fi

        if ! dnf copr --help >/dev/null 2>&1; then
            ui_warn "The DNF COPR command is unavailable."
            ui_info "Install the Fedora COPR plugin and rerun bootstrap."
            exit 0
        fi

        sudo dnf copr enable -y lihaohong/yazi
        sudo dnf install -y yazi

        if command -v yazi >/dev/null 2>&1; then
            ui_success "Yazi installed: $(yazi --version | head -n 1)"
        else
            ui_fail "Yazi installation completed but 'yazi' is not on PATH."
            exit 1
        fi
        ;;
esac
