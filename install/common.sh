#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=install/lib/ui.sh
source "$ROOT_DIR/install/lib/ui.sh"

ui_step "Common setup"
ui_success "Nothing to install yet. Stow packages will be added one at a time."
