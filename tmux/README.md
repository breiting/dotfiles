# tmux

Shared tmux configuration for Fedora Linux and macOS.

## Current scope

The configuration is deliberately plugin-free.

It keeps the useful parts of the previous setup:

- `C-a` as the prefix;
- windows and panes starting at `1`;
- automatic window renumbering;
- mouse support;
- a larger history buffer;
- hyperlink and RGB terminal capabilities;
- passthrough support;
- configuration reload with `<prefix> r`;
- clipboard integration when `pbcopy` or `wl-copy` is available.

## Clipboard

The same configuration is used on both platforms.

On macOS, copy mode uses `pbcopy`.

On Wayland systems, copy mode uses `wl-copy` when it is installed. If neither
command exists, tmux simply keeps its normal internal copy buffer behaviour.

`wl-clipboard` is intentionally not added to the Fedora baseline yet. It should
only become a package dependency if clipboard integration is actually wanted
on the Fedora machines.

## Plugins

The legacy configuration used:

- TPM;
- vim-tmux-navigator;
- Dracula;
- tmux-sensible;
- tmux-yank.

None of them are migrated yet.

The new configuration should first prove useful without a plugin manager.
`vim-tmux-navigator` can be reconsidered together with the Neovim configuration,
because that integration spans both tools.

## Migration

Inspect and remove the old Stow links first:

```sh
stow --dir ~/workspace/dotfiles --target "$HOME" --delete --simulate --verbose=1 tmux
stow --dir ~/workspace/dotfiles --target "$HOME" --delete tmux
```

Then activate the package from the new repository:

```sh
cd ~/workspace/dotfiles-ng
./bootstrap
```

Existing tmux servers do not automatically reread the new configuration. Start
a new server or reload it with `<prefix> r`.
