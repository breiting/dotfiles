# Neovim tooling ownership

Neovim tooling is split into two layers.

## Workstation-managed tools

These are useful outside Neovim or are more reliable through the native package
manager.

On macOS:

- `tree-sitter-cli` — Homebrew
- `pyright` — Homebrew

On Fedora:

- `tree-sitter-cli` — DNF

Pyright remains Mason-managed on Fedora.

## Mason-managed tools

The Mason list lives in:

```text
nvim/.config/nvim/lua/mason_tools.lua
```

It currently contains language servers, formatters and linters whose main
consumer is Neovim.

The list is platform-aware: `pyright` is included for Fedora but omitted on
macOS.

## One required plugins.lua adjustment

Because `plugins.lua` may already contain local edits made after the previous
delta, this delta deliberately does not overwrite that file.

Replace its inline Mason Tool Installer list:

```lua
ensure_installed = {
    ...
},
```

with:

```lua
ensure_installed = require("mason_tools"),
```

Keep:

```lua
run_on_start = false,
```

The bootstrap can then explicitly offer to run:

```text
MasonToolsInstallSync
```

headlessly after the Neovim configuration is active.

This keeps package installation out of ordinary Neovim startup.
