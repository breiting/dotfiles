# tmux

Shared tmux configuration for Fedora Linux and macOS.

## Plugins

tmux plugins are managed by TPM, but TPM is installed by the workstation
bootstrap rather than cloning repositories from inside `tmux.conf`.

Current plugins:

- `tmux-plugins/tpm`
- `christoomey/vim-tmux-navigator`

The bootstrap:

1. activates the tmux Stow package;
2. checks whether TPM exists below `~/.config/tmux/plugins/tpm`;
3. offers to clone TPM when missing;
4. runs TPM's command-line `install_plugins` helper.

This means shell or tmux startup does not perform network installations.

TPM can still be used interactively:

```text
<prefix> I       install newly declared plugins
<prefix> U       update plugins
<prefix> Alt-u   remove plugins no longer declared
```

With this configuration the prefix is `C-a`.

## vim-tmux-navigator

The tmux side is installed now because pane/split navigation is part of the
daily tmux workflow.

The corresponding Neovim plugin will be added when the Neovim configuration is
migrated. Until then the tmux plugin still handles navigation between tmux
panes; seamless movement through Neovim splits requires the Neovim side too.

Default navigation:

```text
Ctrl-h  left
Ctrl-j  down
Ctrl-k  up
Ctrl-l  right
Ctrl-\  previous
```

## Migration

After migrating the tmux Stow package, rerun:

```sh
./bootstrap
```

and accept TPM installation. Existing tmux servers can then reload with:

```text
C-a r
```
