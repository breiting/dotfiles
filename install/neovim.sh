#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=install/lib/ui.sh
source "$ROOT_DIR/install/lib/ui.sh"
# shellcheck source=config/neovim.env
source "$ROOT_DIR/config/neovim.env"

readonly NEOVIM_REPOSITORY="https://github.com/neovim/neovim.git"
readonly NEOVIM_BIN="$NEOVIM_INSTALL_PREFIX/bin/nvim"

installed_version() {
    if [[ -x "$NEOVIM_BIN" ]]; then
        "$NEOVIM_BIN" --version 2>/dev/null | head -n 1 | awk '{print $2}'
    fi
}

build_jobs() {
    if command -v nproc >/dev/null 2>&1; then
        nproc
    elif command -v sysctl >/dev/null 2>&1; then
        sysctl -n hw.ncpu 2>/dev/null || printf '1\n'
    else
        printf '1\n'
    fi
}

check_build_tools() {
    local missing=()
    local tool

    for tool in git cmake ninja make; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing+=("$tool")
        fi
    done

    if [[ "$(uname -s)" == "Darwin" ]] && ! xcrun --find clang >/dev/null 2>&1; then
        missing+=("Apple Clang / Xcode Command Line Tools")
    elif [[ "$(uname -s)" == "Linux" ]] && ! command -v gcc >/dev/null 2>&1; then
        missing+=("gcc")
    fi

    if (( ${#missing[@]} > 0 )); then
        ui_warn "Neovim build prerequisites are missing:"
        for tool in "${missing[@]}"; do
            printf '      - %s\n' "$tool"
        done
        ui_info "Install the platform package baseline and rerun ./bootstrap."
        return 1
    fi
}

ui_step "Neovim source build"

current_version="$(installed_version || true)"

if [[ "$current_version" == "$NEOVIM_VERSION" ]]; then
    ui_success "Neovim $NEOVIM_VERSION is already installed in $NEOVIM_INSTALL_PREFIX."
    exit 0
fi

if [[ -n "$current_version" ]]; then
    ui_info "Installed source build: $current_version"
else
    ui_info "No Neovim source build found in $NEOVIM_INSTALL_PREFIX."
fi
ui_info "Configured release: $NEOVIM_VERSION"

if ! check_build_tools; then
    exit 0
fi

if ! ui_confirm "Build and install Neovim $NEOVIM_VERSION from source?"; then
    ui_warn "Neovim source build skipped."
    exit 0
fi

mkdir -p "$(dirname "$NEOVIM_SOURCE_DIR")"

if [[ ! -d "$NEOVIM_SOURCE_DIR/.git" ]]; then
    if [[ -e "$NEOVIM_SOURCE_DIR" ]]; then
        ui_fail "Source path exists but is not a Git repository: $NEOVIM_SOURCE_DIR"
        exit 1
    fi

    ui_step "Cloning Neovim"
    git clone "$NEOVIM_REPOSITORY" "$NEOVIM_SOURCE_DIR"
else
    ui_step "Fetching Neovim releases"
    git -C "$NEOVIM_SOURCE_DIR" fetch --tags --prune origin
fi

if ! git -C "$NEOVIM_SOURCE_DIR" rev-parse --verify --quiet "${NEOVIM_VERSION}^{commit}" >/dev/null; then
    ui_fail "Configured Neovim tag does not exist: $NEOVIM_VERSION"
    exit 1
fi

if [[ -n "$(git -C "$NEOVIM_SOURCE_DIR" status --porcelain)" ]]; then
    ui_fail "Neovim source tree contains local changes: $NEOVIM_SOURCE_DIR"
    ui_info "The bootstrap will not discard them automatically."
    exit 1
fi

ui_step "Checking out $NEOVIM_VERSION"
git -C "$NEOVIM_SOURCE_DIR" checkout --detach "$NEOVIM_VERSION"

# CMake state is version-specific. Rebuild it cleanly when changing releases.
rm -rf "$NEOVIM_SOURCE_DIR/build" "$NEOVIM_SOURCE_DIR/.deps"

ui_step "Building Neovim $NEOVIM_VERSION"
make \
    -C "$NEOVIM_SOURCE_DIR" \
    -j"$(build_jobs)" \
    CMAKE_BUILD_TYPE=Release \
    CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$NEOVIM_INSTALL_PREFIX"

ui_step "Installing Neovim into $NEOVIM_INSTALL_PREFIX"
make -C "$NEOVIM_SOURCE_DIR" install

if [[ ! -x "$NEOVIM_BIN" ]]; then
    ui_fail "Neovim build completed but $NEOVIM_BIN was not created."
    exit 1
fi

built_version="$(installed_version || true)"
if [[ "$built_version" != "$NEOVIM_VERSION" ]]; then
    ui_fail "Expected $NEOVIM_VERSION but installed binary reports ${built_version:-unknown}."
    exit 1
fi

ui_success "Neovim $NEOVIM_VERSION installed successfully."
ui_info "Binary: $NEOVIM_BIN"
