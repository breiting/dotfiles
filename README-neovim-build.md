# Neovim source build

Neovim is built from the official Git repository rather than installed as a
system package.

The source build is intentionally separate from the Neovim configuration. The
`nvim` Stow package will be migrated in the next step.

## Version

The desired Git release tag is configured in:

```text
config/neovim.env
```

For example:

```sh
NEOVIM_VERSION="v0.12.4"
```

Updating Neovim later should normally require only changing that tag and
running:

```sh
./bootstrap
```

## Paths

The bootstrap uses:

```text
source:  ~/.local/src/neovim
prefix:  ~/.local
binary:  ~/.local/bin/nvim
```

No `sudo make install` is used.

The source directory is considered bootstrap-managed. The script will fetch
tags and switch it to the configured release, but it refuses to discard local
changes automatically.

## Build

If `~/.local/bin/nvim` already reports the configured version, the build is
skipped.

Otherwise the bootstrap offers to:

1. clone or fetch the official Neovim Git repository;
2. verify that the configured tag exists;
3. check out the release tag in detached HEAD state;
4. remove old `build/` and `.deps/` CMake state;
5. build with `CMAKE_BUILD_TYPE=Release`;
6. install into `~/.local`;
7. verify the installed version.

## Toolchain

Fedora receives the source-build prerequisites through `packages/fedora.txt`.

macOS uses the Apple compiler toolchain supplied by Xcode Command Line Tools,
plus CMake, Ninja, and Gettext from Homebrew.

The build uses Neovim's bundled dependency mechanism. Dependencies such as
LuaJIT, libuv, and tree-sitter are therefore not individually declared in the
workstation package lists.
