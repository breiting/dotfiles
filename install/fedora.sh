#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_FILE="$ROOT_DIR/packages/fedora.txt"

# shellcheck source=install/lib/ui.sh
source "$ROOT_DIR/install/lib/ui.sh"

ui_step "Fedora packages"

if ! command -v dnf >/dev/null 2>&1; then
    ui_fail "DNF is not available on this Fedora system."
    exit 1
fi

if [[ ! -r "$PACKAGE_FILE" ]]; then
    ui_fail "Package list not found: $PACKAGE_FILE"
    exit 1
fi

mapfile -t packages < <(
    sed -e 's/[[:space:]]*#.*$//' \
        -e '/^[[:space:]]*$/d' \
        "$PACKAGE_FILE"
)

if ((${#packages[@]} == 0)); then
    ui_warn "The Fedora package list is empty."
    exit 0
fi

missing_packages=()
for package in "${packages[@]}"; do
    if ! rpm -q "$package" >/dev/null 2>&1; then
        missing_packages+=("$package")
    fi
done

if ((${#missing_packages[@]} == 0)); then
    ui_success "All ${#packages[@]} Fedora baseline packages are already installed."
    exit 0
fi

ui_info "${#missing_packages[@]} of ${#packages[@]} baseline packages are missing:"
for package in "${missing_packages[@]}"; do
    printf '      - %s\n' "$package"
done

if ! ui_confirm "Install the missing Fedora packages?"; then
    ui_warn "Fedora package installation skipped."
    exit 0
fi

ui_info "Running DNF. Sudo may ask for your password."
sudo dnf install -y -- "${missing_packages[@]}"

ui_success "Fedora baseline packages are installed."
