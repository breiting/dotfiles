# Personal scripts

Personal scripts are no longer stored in a Stow package that owns
`~/.local/bin`.

Instead, source files live in:

```text
scripts/
├── common/
├── linux/
└── macos/
```

`install/scripts.sh` creates individual symlinks in `~/.local/bin`.

This lets bootstrap-managed binaries such as the source-built Neovim coexist
with personal scripts in the same executable directory.

## Safety

The installer never overwrites an existing regular file or a symlink managed
elsewhere.

Links created by this installer can be repaired automatically after the
dotfiles repository itself is renamed, because the script can recognize the
old `scripts/<platform>/<name>` target shape.

## First migrated scripts

Common:

- `daily`
- `dn`

Linux only:

- `timer`

The Linux timer remains Linux-only because it currently relies on GNU `date`,
`notify-send`, `paplay`, and the freedesktop sound path.

Other legacy scripts are intentionally deferred until their dependencies and
platform assumptions have been reviewed.

## uv

`uv` is an installed workstation tool, not a dotfile script.

- macOS: Homebrew `uv`
- Fedora: DNF `uv`

`uvx` is included with `uv`; it is the convenience alias for `uv tool run`.
The legacy checked-in `uv` and `uvx` binaries should not be migrated.
