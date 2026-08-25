#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=install/lib/ui.sh
source "$ROOT_DIR/install/lib/ui.sh"

setup_brew_environment() {
    if command -v brew >/dev/null 2>&1; then
        return
    fi

    # Homebrew uses /opt/homebrew on Apple Silicon and /usr/local on Intel Macs.
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
        return 1
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
        install_homebrew || return 1
    else
        ui_success "Homebrew found: $(brew --version | head -n 1)"
    fi

    # Homebrew itself is the source of truth for Homebrew and formula metadata updates.
    if ui_confirm "Check for Homebrew updates now?"; then
        ui_step "Updating Homebrew"
        brew update
        ui_success "Homebrew update check completed: $(brew --version | head -n 1)"
    else
        ui_info "Homebrew update check skipped."
    fi
}

install_brewfile() {
    local brewfile="$ROOT_DIR/packages/Brewfile"

    if [[ ! -f "$brewfile" ]]; then
        ui_fail "Brewfile not found: $brewfile"
        exit 1
    fi

    ui_step "macOS packages"

    if brew bundle check --file "$brewfile" >/dev/null 2>&1; then
        ui_success "All Brewfile packages are already installed."
        return
    fi

    ui_info "The Brewfile contains the current macOS baseline."
    if ! ui_confirm "Install missing Homebrew packages and applications?"; then
        ui_warn "Brewfile installation skipped."
        return
    fi

    brew bundle --file "$brewfile"
    ui_success "Homebrew packages are up to date."
}

ensure_zsh_login_shell() {
    local current_shell

    current_shell="$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')"

    if [[ "$current_shell" == "/bin/zsh" ]]; then
        ui_success "Login shell is already /bin/zsh."
        return
    fi

    ui_warn "Current login shell: ${current_shell:-unknown}"
    if ! ui_confirm "Set /bin/zsh as the login shell?"; then
        ui_info "Login shell change skipped."
        return
    fi

    chsh -s /bin/zsh
    ui_success "Login shell changed to /bin/zsh. It will apply to new terminal sessions."
}

ui_step "macOS bootstrap"

if check_homebrew; then
    install_brewfile
else
    ui_warn "Homebrew is unavailable. Brewfile installation is skipped."
fi

ensure_zsh_login_shell
