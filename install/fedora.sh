#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=install/lib/ui.sh
source "$ROOT_DIR/install/lib/ui.sh"

ui_step "Fedora bootstrap"
ui_success "Fedora support is ready. Package installation will be added next."
