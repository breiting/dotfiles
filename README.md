# Dotfiles

Personal workstation bootstrap and dotfiles for Fedora Linux and macOS.

The repository is intentionally kept small and explicit. Native package managers are used for system software, GNU Stow will manage selected dotfiles, and small Bash scripts provide the orchestration around them.

## Design principles

- Keep the bootstrap small, readable, and safe to run repeatedly.
- Prefer native package managers: DNF on Fedora and Homebrew on macOS.
- Keep common and platform-specific configuration separate where it matters.
- Do not automatically activate every configuration stored in the repository.
- Add packages and dotfiles deliberately, one component at a time.
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
- does not create any dotfile symlinks yet.

Running the bootstrap again is expected to be safe. On Fedora, already installed packages are detected before DNF is invoked.

## Fedora package baseline

Fedora packages are declared in `packages/fedora.txt` with one package per line. Blank lines and comments are ignored.

The baseline is intentionally small:

```text
git
stow
zsh
tmux
curl
wget
ripgrep
fd-find
fzf
bat
```

Additional development tools, desktop packages, third-party repositories, and applications will be added only when we introduce the component that needs them.

## Repository layout

```text
.
├── bootstrap
├── install/
│   ├── common.sh
│   ├── fedora.sh
│   ├── macos.sh
│   └── lib/
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

The next milestone is to introduce the first deliberately selected Stow package. Package lists will grow alongside the configuration that actually requires them.
