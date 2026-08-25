# SketchyBar

Minimal SketchyBar configuration modeled after the previous Fedora Waybar.

## Layout

```text
 1  2  3  4  5  6  7  8  9  0        Firefox        CPU  VOL  NET  BAT  DATE
```

Left:

- persistent AeroSpace workspaces 1..0;
- active workspace uses a brighter background.

Center:

- currently focused/front application.

Right:

- CPU percentage;
- audio volume/mute state;
- default network interface / offline state;
- battery percentage and charging state;
- date and time.

The design deliberately mirrors the old Waybar:

- dark `#111111` bar;
- `#222222` item backgrounds;
- small rounded item backgrounds;
- muted inactive workspaces;
- no shadows, blur or animated UI;
- JetBrainsMono Nerd Font.

## AeroSpace integration

AeroSpace officially supports `exec-on-workspace-change` for bar integration.

`install/aerospace-sketchybar.sh` adds that hook only when it is not already
present. It does not replace the rest of the AeroSpace configuration.

The hook triggers SketchyBar's custom `aerospace_workspace_change` event, so
workspace highlighting updates immediately instead of polling.

## Installation

SketchyBar is installed from FelixKratz's Homebrew tap.

The Brewfile trusts only the concrete `borders` and `sketchybar` formulae from
that tap.

The bootstrap stows:

```text
~/.config/sketchybar/
```

and offers to enable the user-scoped Homebrew service.

## Debugging

Stop the service and run SketchyBar directly to see plugin output:

```sh
brew services stop sketchybar
sketchybar
```

After editing the configuration:

```sh
sketchybar --reload
```

AeroSpace can be reloaded with:

```sh
aerospace reload-config
```

SketchyBar requires macOS "Displays have separate Spaces" to remain enabled.
