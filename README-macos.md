# macOS desktop layer

The macOS layer aims for a fast keyboard-driven desktop similar in spirit to
the Fedora Sway/Hyprland setup.

## Window management

- AeroSpace: tiling, workspaces and keyboard navigation
- JankyBorders (`borders`): active-window border
- Vicinae: launcher and clipboard history
- Ghostty: terminal

## User preferences

`install/macos-defaults.sh` applies only user-scoped preferences and asks before
changing them.

Current choices:

- fast key repeat (`KeyRepeat=1`)
- short repeat delay (`InitialKeyRepeat=10`)
- press-and-hold disabled so held keys repeat
- empty, auto-hidden Dock
- zero Dock reveal delay
- short Dock animation duration
- launch animations disabled
- Mission Control animation shortened
- automatic Spaces reordering disabled
- Apple menu bar auto-hidden
- Finder animations disabled
- general window animations disabled where macOS exposes a preference

The script restarts Dock, Finder and SystemUIServer. Keyboard/global changes may
require logout/login.

## Wallpaper

The bootstrap creates:

```text
~/Pictures/Wallpapers/black.png
```

macOS wallpaper internals have changed repeatedly across releases and are not a
good place for a brittle `defaults` hack. Set this generated image once through
System Settings > Wallpaper. The preference is retained per user.

## JankyBorders

JankyBorders is installed through FelixKratz's Homebrew tap as the `borders`
formula.

Its config is stowed to:

```text
~/.config/borders/bordersrc
```

The initial style is deliberately simple:

- rounded border
- width 5
- visible active border
- transparent inactive border

The bootstrap offers to enable it as a user Homebrew service.

## SketchyBar

SketchyBar is intentionally not included in this delta. Hiding the native menu
bar is independent from the future bar implementation, so SketchyBar can be
designed as its own focused step instead of copying an arbitrary prebuilt
configuration.
