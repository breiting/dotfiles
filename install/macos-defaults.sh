#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/install/lib/ui.sh"

[[ "$(uname -s)" == "Darwin" ]] || exit 0

ui_step "macOS preferences"

if ! ui_confirm "Apply fast, minimal macOS UI preferences for this user?"; then
    ui_info "macOS preference changes skipped."
    exit 0
fi

# Keyboard -------------------------------------------------------------------
# Lower values are faster. These are deliberately aggressive but still usable.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Dock -----------------------------------------------------------------------
# Keep the Dock available as an escape hatch, but empty and hidden.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock static-only -bool true

# Remove all persistent app and folder tiles. Running applications can still
# appear temporarily because static-only is enabled.
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array

# Mission Control / Spaces ---------------------------------------------------
# Preserve workspace ordering so AeroSpace workspaces do not feel shuffled.
defaults write com.apple.dock mru-spaces -bool false

# Menu bar -------------------------------------------------------------------
# Hide Apple's menu bar; SketchyBar will become the visible status surface.
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# Finder ---------------------------------------------------------------------
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# General UI -----------------------------------------------------------------
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Screenshots ----------------------------------------------------------------
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

# Apply processes that safely reload in-session.
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

ui_success "macOS preferences applied."
ui_info "Keyboard and some global UI settings may require logout/login."
