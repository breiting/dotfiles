# Dotfiles

Personal workstation bootstrap and dotfiles for Fedora Linux and macOS.

The repository is intentionally kept small and explicit. Native package managers are used for system software, GNU Stow manages deliberately selected dotfiles, and small Bash scripts provide the orchestration around them.

## Design principles

- Keep the bootstrap small, readable, and safe to run repeatedly.
- Prefer native package managers: DNF on Fedora and Homebrew on macOS.
- Keep common and platform-specific configuration separate where it matters.
- Do not automatically activate every configuration stored in the repository.
- Add packages and dotfiles deliberately, one component at a time.
- Never overwrite existing configuration during migration.
- Avoid framework-style abstractions unless they solve a real problem.
- Document non-obvious decisions in English.

## Supported systems

- Fedora Linux
- macOS

Other operating systems exit without making changes.

## Bootstrap

Run from the repository root:

```sh
./bootstrap
```

The bootstrap currently:

- identifies Fedora Linux or macOS;
- on Fedora, checks a small baseline package list and offers to install only missing packages with DNF;
- on macOS, detects Homebrew and can install it using the official installer;
- when Homebrew already exists, shows the installed version and offers to run the official update check;
- safely offers to activate the `git` Stow package.

Running the bootstrap again is expected to be safe.

## Fedora package baseline

Fedora packages are declared in `packages/fedora.txt` with one package per line. Blank lines and comments are ignored.

The baseline is intentionally small:

```text
git
stow
zsh
tmux
curl
wget2-wget
ripgrep
fd-find
fzf
bat
```

`wget2-wget` is used on Fedora because it provides the `wget` command while remaining an explicit RPM package declaration.

## Dotfile migration

Dotfile packages are migrated one at a time.

The bootstrap never adopts or overwrites an existing file or symlink that belongs to another repository. Before activating a package, it performs a simulated Stow run. If Stow reports a conflict, the package is skipped and the existing configuration is left untouched.

For example, while migrating from an older repository:

```text
~/.gitconfig -> ~/workspace/dotfiles/git/.gitconfig
```

the new repository will not replace that link automatically.

A controlled migration is:

```sh
# Inspect removal from the old repository.
stow --dir ~/workspace/dotfiles --target "$HOME" --delete --simulate --verbose=1 git

# Remove only the old Stow links.
stow --dir ~/workspace/dotfiles --target "$HOME" --delete git

# Return to the new repository and activate the package.
cd ~/workspace/dotfiles-ng
./bootstrap
```

Rollback is the reverse operation: delete the new package links and Stow the package from the old repository again.

## Git dotfiles

`git` is the first migrated Stow package and currently contains:

```text
git/
├── .gitconfig
└── .gitignore
```

The legacy `.git-completion.zsh` has intentionally not been migrated yet. Shell completion belongs to the later Zsh cleanup and should not be carried forward merely because it existed in the old repository.

## Repository layout

```text
.
├── bootstrap
├── git/
│   ├── .gitconfig
│   └── .gitignore
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

## Homebrew updates

The bootstrap does not infer that Homebrew is outdated from its local version number alone. Determining whether an update exists requires contacting Homebrew's repositories. When Homebrew is already installed, the bootstrap therefore offers an explicit `brew update` check instead of silently changing it.

## Next steps

After the Git package has been migrated and tested on the existing machines, the next dotfile package will be introduced deliberately.
