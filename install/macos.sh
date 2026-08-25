#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=install/lib/ui.sh
source "$ROOT_DIR/install/lib/ui.sh"

setup_brew_environment() {
    if command -v brew >/dev/null 2>&1; then
        return
    fi

    # Homebrew's supported default prefix differs between Apple Silicon and Intel Macs.
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

install_homebrew() {
    ui_step "Homebrew is not installed"
    ui_info "The official Homebrew installer will be used."

    if ! ui_confirm "Install Homebrew now?"; then
        ui_warn "Homebrew installation skipped."
        return
    fi

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    setup_brew_environment

    if command -v brew >/dev/null 2>&1; then
        ui_success "Homebrew installed: $(brew --version | head -n 1)"
    else
        ui_fail "Homebrew installation finished, but 'brew' is not available in this shell."
        exit 1
    fi
}

check_homebrew() {
    setup_brew_environment

    if ! command -v brew >/dev/null 2>&1; then
        install_homebrew
        return
    fi

    ui_success "Homebrew found: $(brew --version | head -n 1)"

    # Homebrew itself is the source of truth for updating Homebrew and formula metadata.
    # We intentionally do not guess whether a version number is stale without contacting
    # Homebrew's remote repositories.
    if ui_confirm "Check for Homebrew updates now?"; then
        ui_step "Updating Homebrew"
        brew update
        ui_success "Homebrew update check completed: $(brew --version | head -n 1)"
    else
        ui_info "Homebrew update check skipped."
    fi
}

ui_step "macOS bootstrap"
check_homebrew
ui_success "macOS base check completed. Brewfile installation will be added later."
