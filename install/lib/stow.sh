#!/usr/bin/env bash

# This file is sourced by install scripts. It intentionally does not enable
# shell options or load UI helpers on its own.

stow_package() {
    local package="$1"
    local package_dir="$ROOT_DIR/$package"
    local preview

    if [[ ! -d "$package_dir" ]]; then
        ui_fail "Stow package not found: $package"
        return 1
    fi

    ui_step "Dotfiles: $package"

    # A simulated restow gives Stow a chance to detect files or symlinks that
    # are already managed elsewhere. During migration we never adopt or
    # overwrite such files automatically.
    if ! preview="$(
        stow \
            --dir "$ROOT_DIR" \
            --target "$HOME" \
            --restow \
            --simulate \
            --verbose=1 \
            "$package" 2>&1
    )"; then
        ui_warn "Cannot activate '$package' safely."
        printf '\n%s\n\n' "$preview"
        ui_info "Existing files or symlinks were left untouched."
        ui_info "Migrate this package manually, then run ./bootstrap again."
        return 0
    fi

    if ! ui_confirm "Activate or refresh the '$package' dotfiles?"; then
        ui_warn "Skipping '$package'."
        return 0
    fi

    stow \
        --dir "$ROOT_DIR" \
        --target "$HOME" \
        --restow \
        "$package"

    ui_success "'$package' dotfiles are active."
}
