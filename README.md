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

The initial bootstrap intentionally does very little:

- identifies Fedora Linux or macOS;
- verifies the platform-specific bootstrap path;
- on macOS, detects Homebrew and can install it using the official installer;
- when Homebrew already exists, shows the installed version and offers to run the official update check;
- performs no package installation and creates no dotfile symlinks yet.

This gives us a safe baseline that can be tested repeatedly before adding workstation packages or Stow configuration.

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

The next milestone is to migrate and review the minimal Fedora package baseline from the previous Ansible configuration. Dotfile packages will only be introduced after the package bootstrap is working safely on both Fedora machines.
