# Fedora Sway desktop

This layer is Fedora/Linux-only and is activated by the common bootstrap only
on Linux.

Managed Stow packages:

- `sway`
- `swaync`
- `waybar`
- `wireplumber`
- `wofi`

## Machine-local Sway configuration

Hardware-specific state is deliberately outside the Stow package:

```text
~/.config/sway-host/
├── machine.conf
└── outputs.conf
```

`install/sway-host.sh` creates these files only when missing.

`machine.conf` stores the desired physical window-manager modifier:

```text
Super / Windows -> Mod4
Alt / Option    -> Mod1
```

This lets the second physical key left of Space remain the window-manager key
across an Apple keyboard, the Fedora laptop keyboard, and macOS/AeroSpace.

`outputs.conf` stores display-specific scaling/layout. Existing legacy hostnames
are migrated as defaults:

- `fedo` -> `output * scale 1`
- `fedora-air` -> `output eDP-1 scale 1.5`

These files are intentionally not committed to Git.

## Sway / AeroSpace muscle memory

```text
Fedora Sway             macOS AeroSpace
$mod+Enter               Alt+Enter
$mod+Q                   Alt+Q
$mod+H/J/K/L             Alt+H/J/K/L
$mod+Shift+H/J/K/L       Alt+Shift+H/J/K/L
$mod+1..0                Alt+1..0
$mod+Shift+1..0          Alt+Shift+1..0
$mod+F                   Alt+F
$mod+T                   Alt+T
$mod+R                   Alt+R
$mod+Space               Alt+Space
Wofi                     Vicinae
```

The old Mod1-based umlaut shortcuts were removed because Alt/Option may itself
be the Sway modifier. Umlauts should be configured through XKB/Compose instead.

## Waybar

Waybar now mirrors the SketchyBar information hierarchy:

```text
CPU  WORKSPACES  WINDOW                         NET  VOL  BAT  DATE/TIME
```

CPU is clickable and opens `btop` in Ghostty. Volume opens `pavucontrol`.

## SwayNotificationCenter

The existing notification-center concept is retained but visually simplified to
match Waybar: dark, compact, small corner radii, no decorative effects.

## WirePlumber

The old ALSA suspend rule is retained for now. It keeps output nodes awake to
avoid resume delay. If neither Fedora machine benefits from this workaround,
remove the entire `wireplumber` package later.
