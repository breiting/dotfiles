# Script migration 08.2

The legacy personal scripts have been reviewed individually instead of copied
as one `~/.local/bin` Stow package.

## Removed

The following legacy files are intentionally not migrated:

- `env` — obsolete; Zsh now owns `~/.local/bin` PATH setup.
- `frontmatter.sh` — a one-off migration script with a hard-coded historical
  directory.
- checked-in `uv` and `uvx` — replaced by the real `uv` package.

## Common

The following scripts are linked on Fedora and macOS:

- `daily`, `dn`
- `on`, `om`
- `zf`, `zj`, `zl`, `zp`
- `prettier-safe-md`
- `stock-rename`
- `startai`
- `n8n`

The note generators were normalized to Bash, create their target directories,
and keep their existing command names so muscle memory does not change.

`startai` and `n8n` remain optional Docker helpers. They now fail clearly when
Docker is unavailable instead of failing halfway through the command.

## Linux only

- `timer`
- `mdcopy`
- `rbwmenu`
- `start-sway`
- `monitor-sway`
- `monitor-hyprland`
- `v`
- `polish-text`

These depend on Wayland, Sway/Hyprland, freedesktop notifications, Linux GUI
applications, or Linux-specific monitor/output commands.

`polish-text` was updated to use the OpenAI Responses endpoint, checks its
dependencies explicitly, and still reads the key from `~/.openai.key` by
default. The key is never stored in the dotfiles repository.

## macOS only

- `writing`
- `zettelsync`

`writing` depends on `system_profiler` and a personal
`~/workspace/nvim-writer.nvim/tmux.conf`.

`zettelsync` targets a mounted `/Volumes/...` path by default. Both source and
target can now be overridden with `ZETTEL_SOURCE` and `ZETTEL_TARGET`.

## Deferred decision

The scripts still encode several personal note-directory conventions
(`~/notes`, `~/zettel`, `~/mmi`). They are portable between Fedora and macOS,
but a later cleanup could move these locations into one small user-local
configuration file if desired.
