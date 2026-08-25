# Desktop configuration migration

This delta introduces three configuration packages:

- `lazygit` — shared between Fedora and macOS;
- `ghostty` — shared between Fedora and macOS;
- `aerospace` — macOS only.

## LazyGit

Only `config.yml` is retained. The legacy repository contained identical
`config.yml` and `config.yaml` files, so the duplicate is removed.

## Ghostty

Ghostty uses the XDG configuration path on both Fedora and macOS.

The configuration uses the current `config.ghostty` filename and keeps the old
behaviour intentionally minimal:

- 95% background opacity;
- undecorated windows;
- shell integration without cursor manipulation;
- no close confirmation;
- center quick-terminal settings;
- macOS hidden titlebar.

No theme framework or font dependency is introduced yet.

## AeroSpace

The AeroSpace key model mirrors the Fedora window managers as closely as is
practical on macOS.

Linux concept -> macOS mapping:

```text
Super/Mod4        -> Option/Alt
Super+Enter       -> Alt+Enter
Super+Q           -> Alt+Q
Super+F           -> Alt+F
Super+T           -> Alt+T
Super+H/J/K/L     -> Alt+H/J/K/L
Super+Shift+H/J/K/L
                  -> Alt+Shift+H/J/K/L
Super+1..0        -> Alt+1..0
Super+Shift+1..0  -> Alt+Shift+1..0
Super+R           -> Alt+R resize mode
```

`Alt+Space` is intentionally reserved for a future launcher.

AeroSpace starts at login for the current macOS user because that preference is
part of this user's window-manager configuration, not merely application
installation.

The initial application routing is intentionally small:

- Ghostty -> workspace 1
- Firefox -> workspace 2
- Thunderbird and Signal -> workspace 3

More application rules should only be added after they prove stable in daily
use.

## Migration

As with the previous packages, remove old Stow links explicitly before
activating the new package.

Examples:

```sh
stow --dir ~/workspace/dotfiles --target "$HOME" --delete --simulate --verbose=1 lazygit
stow --dir ~/workspace/dotfiles --target "$HOME" --delete lazygit

stow --dir ~/workspace/dotfiles --target "$HOME" --delete --simulate --verbose=1 ghostty
stow --dir ~/workspace/dotfiles --target "$HOME" --delete ghostty
```

On macOS:

```sh
stow --dir ~/workspace/dotfiles --target "$HOME" --delete --simulate --verbose=1 aerospace
stow --dir ~/workspace/dotfiles --target "$HOME" --delete aerospace
```

Then rerun:

```sh
./bootstrap
```
