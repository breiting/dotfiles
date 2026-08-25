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

## Zsh startup layout

Zsh uses a deliberately simple startup chain:

```text
~/.zshenv
    |
    +-- XDG_CONFIG_HOME
    +-- XDG_CACHE_HOME
    +-- XDG_DATA_HOME
    +-- XDG_STATE_HOME
    +-- ZDOTDIR
          |
          v
~/.config/zsh/.zshrc
          |
          +-- env.zsh
          +-- aliases.zsh
          +-- fzf.zsh
          +-- prompt.zsh
```

There is intentionally no second `.zshenv` below `ZDOTDIR`.

The root `~/.zshenv` only establishes the XDG environment and points Zsh at `~/.config/zsh`. Interactive environment settings such as PATH, editor, Homebrew paths, Starship configuration, and GPG terminal handling live in `env.zsh`.

Generated runtime files such as `zcompdump` and shell history are written below the XDG cache/state directories and are not stored in Git.

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
