# Dotfiles

Personal workstation bootstrap and dotfiles for Fedora Linux and macOS.

The repository is intentionally small and explicit. Native package managers install system software, GNU Stow manages deliberately selected dotfiles, and small Bash scripts provide the orchestration.

## Current bootstrap scope

Run:

```sh
./bootstrap
```

The bootstrap currently:

- detects Fedora Linux or macOS;
- on Fedora, offers to install the small package baseline from `packages/fedora.txt`;
- on macOS, installs Homebrew when requested, optionally checks Homebrew for updates, and offers to install the Brewfile baseline;
- on macOS, verifies that `/bin/zsh` is the login shell and can change it when requested;
- safely offers to activate the `git` and `zsh` Stow packages;
- never adopts or overwrites an existing file or symlink from another dotfiles repository.

## Dotfile migration

Packages are migrated one at a time. During the transition from an older repository, a Stow conflict is expected and is treated as a safe skip.

Example for migrating a package named `zsh`:

```sh
stow --dir ~/workspace/dotfiles --target "$HOME" --delete --simulate --verbose=1 zsh
stow --dir ~/workspace/dotfiles --target "$HOME" --delete zsh

cd ~/workspace/dotfiles-ng
./bootstrap
```

The old repository can be re-stowed at any time to roll back.

## Zsh

The Zsh setup intentionally starts smaller than the legacy configuration.

It keeps:

- `ZDOTDIR=~/.config/zsh`;
- XDG base directories;
- history and completion;
- fzf integration;
- a small set of aliases;
- Starship.

It deliberately does not migrate yet:

- generated `.zcompdump` files;
- Android, Flutter, Processing, Go, or other project-specific environment variables;
- `LD_LIBRARY_PATH`;
- shell plugins that clone themselves during shell startup;
- the legacy `.git-completion.zsh`.

These can be reintroduced individually when there is a concrete need.

On macOS, the bootstrap uses Apple's `/bin/zsh` instead of installing a second Homebrew Zsh.

## macOS Brewfile baseline

The first macOS baseline includes CLI tools required by the shell and everyday workstation use, plus:

- Ghostty
- Karabiner-Elements
- Hammerspoon
- Bitwarden
- Maccy
- AeroSpace

Larger or more specialized applications such as Docker, UTM, GIMP, Signal, VLC, SketchyBar, JankyBorders, Vicinae, and the source-built Neovim setup are intentionally deferred.

## Repository layout

```text
.
├── bootstrap
├── git/
├── zsh/
├── install/
│   ├── common.sh
│   ├── fedora.sh
│   ├── macos.sh
│   └── lib/
│       ├── stow.sh
│       └── ui.sh
├── macos/
│   └── defaults.sh
└── packages/
    ├── Brewfile
    └── fedora.txt
```
