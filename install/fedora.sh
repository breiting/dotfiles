#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=install/lib/ui.sh
source "$ROOT_DIR/install/lib/ui.sh"

PACKAGES_FILE="$ROOT_DIR/packages/fedora.txt"

ui_step "Fedora packages"

if [[ ! -f "$PACKAGES_FILE" ]]; then
    ui_fail "Fedora package list not found: $PACKAGES_FILE"
    exit 1
fi

packages=()
missing_packages=()

while IFS= read -r package; do
    # Strip leading/trailing whitespace and ignore comments/blank lines.
    package="${package#"${package%%[![:space:]]*}"}"
    package="${package%"${package##*[![:space:]]}"}"

    [[ -z "$package" || "$package" == \#* ]] && continue
    packages+=("$package")
done < "$PACKAGES_FILE"

if (( ${#packages[@]} == 0 )); then
    ui_warn "Fedora package list is empty."
    exit 0
fi

for package in "${packages[@]}"; do
    if ! rpm -q "$package" >/dev/null 2>&1; then
        missing_packages+=("$package")
    fi
done

if (( ${#missing_packages[@]} == 0 )); then
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

# Fedora 41+ uses DNF5. Do not put the conventional `--` option separator
# before package specs: DNF5 interprets it as an install-command argument and
# rejects `dnf install -- package`.
#
# Package names come from our version-controlled package list, so no separator
# is needed here.
sudo dnf install -y "${missing_packages[@]}"

ui_success "Fedora package installation completed."
