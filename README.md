# 🏠 Dotfiles

Personal workstation configuration for **Fedora + Sway** and **macOS + AeroSpace**.

> One repository, two operating systems, and as much shared muscle memory as possible.

This repository is intentionally boring in the best possible way: small shell scripts, native package managers, GNU Stow, and platform-specific configuration only where it is actually needed.

The goal is not to reproduce every tiny preference automatically. The goal is to get a new machine from a clean installation to a comfortable, productive terminal-first workstation quickly, safely, and understandably.

## ✨ Philosophy

A few rules keep this repository maintainable:

- **Prefer simple shell scripts over clever abstractions.**
- Use the native package manager: **DNF on Fedora**, **Homebrew on macOS**.
- Use **GNU Stow** for dotfile symlinks.
- Keep common configuration common, but do not force Linux and macOS into the same shape where they genuinely differ.
- Keep machine-specific hardware configuration **outside Git**.
- Never silently overwrite existing dotfiles during migration.
- Make the bootstrap safe to run again.
- Automate the useful 90%; keep fragile one-time OS tweaks manual when that is simpler.
- Add configuration because it solves a real problem, not because it is possible.

There is deliberately **no Ansible, Nix/Home Manager, chezmoi, or custom configuration framework** here.

## 🚀 Quick Start

Clone the repository into the workspace:

```sh
mkdir -p ~/workspace
cd ~/workspace
git clone ssh://git@git-ssh.dornegg.com:2222/breiting/dotfiles
cd dotfiles
```

Then run:

```sh
./bootstrap
```

The bootstrap detects the operating system and walks through the setup interactively.

It is intentionally not a fully unattended installer. Potentially significant actions such as package installation, Stow activation, Neovim builds, macOS defaults, and services ask before changing the system.

### 🐧 Fedora

Supported Linux target: **Fedora**.

The bootstrap:

1. reads `packages/fedora.txt`;
2. checks installed RPMs;
3. offers to install missing packages with DNF;
4. activates common Stow packages;
5. builds Neovim from source when necessary;
6. installs/configures the Fedora Sway desktop layer;
7. creates machine-local Sway settings;
8. links personal Linux scripts.

Run:

```sh
./bootstrap
```

On the first Sway setup, choose which physical key should act as the window-manager modifier:

```text
1) Super / Windows
2) Alt / Option
```

The idea is to use the **second physical key left of Space** regardless of the keyboard.

### 🍎 macOS

The bootstrap checks whether Homebrew exists.

If Homebrew is missing, it offers to install it using the official Homebrew installer. If it already exists, it offers to run `brew update`.

Packages and applications are then managed through:

```text
packages/Brewfile
```

The bootstrap also offers to make `/bin/zsh` the login shell.

After the package layer it activates AeroSpace, JankyBorders and SketchyBar and offers to apply the macOS UI preferences from `install/macos-defaults.sh`.

Some macOS preferences only become fully visible after logout/login.

## 🗺️ Workstation Map

| Purpose               | Fedora   | macOS        |
| --------------------- | -------- | ------------ |
| Package manager       | DNF      | Homebrew     |
| Window manager        | Sway     | AeroSpace    |
| Status bar            | Waybar   | SketchyBar   |
| Launcher              | Wofi     | Vicinae      |
| Notifications         | SwayNC   | macOS        |
| Active-window border  | Sway     | JankyBorders |
| Terminal              | Ghostty  | Ghostty      |
| Shell                 | Zsh      | Zsh          |
| Prompt                | Starship | Starship     |
| Multiplexer           | tmux     | tmux         |
| Editor                | Neovim   | Neovim       |
| Terminal file manager | Yazi     | Yazi         |
| Git UI                | LazyGit  | LazyGit      |
| Dotfile deployment    | GNU Stow | GNU Stow     |

The desktop environments are intentionally different implementations of the same basic workflow rather than exact copies of each other.

## 🗂️ Repository Structure

The important top-level pieces are:

```text
dotfiles/
├── bootstrap                  # Main entry point
├── config/
│   └── neovim.env             # Neovim version/build configuration
├── install/                   # Bootstrap implementation
├── packages/
│   ├── Brewfile               # macOS package baseline
│   └── fedora.txt             # Fedora package baseline
├── scripts/
│   ├── common/
│   ├── linux/
│   └── macos/
│
├── git/                       # Stow package
├── zsh/                       # Stow package
├── tmux/                      # Stow package
├── nvim/                      # Stow package
├── lazygit/                   # Stow package
├── ghostty/                   # Stow package
│
├── sway/                      # Fedora
├── swaync/                    # Fedora
├── waybar/                    # Fedora
├── wireplumber/               # Fedora
├── wofi/                      # Fedora
│
├── aerospace/                 # macOS
├── borders/                   # macOS / JankyBorders
└── sketchybar/                # macOS
```

Most configuration directories mirror their final location below `$HOME`, which is what makes them usable with GNU Stow.

## 🔗 GNU Stow

Stow is responsible for the actual dotfile symlinks.

For example:

```text
nvim/.config/nvim/init.lua
```

becomes:

```text
~/.config/nvim/init.lua
```

through a symlink into this repository.

The helper in `install/lib/stow.sh` performs a **simulated restow first**. If an existing file or symlink would conflict, the bootstrap does not adopt, delete, or overwrite it automatically.

That is especially important when migrating an older dotfiles repository.

### Check a symlink

```sh
readlink ~/.config/nvim
readlink ~/.config/zsh
```

Or inspect a specific file:

```sh
readlink ~/.config/zsh/.zshrc
```

### Manual Stow preview

From the repository root:

```sh
stow --target "$HOME" --restow --simulate --verbose=1 zsh
```

### Activate manually

```sh
stow --target "$HOME" --restow zsh
```

### Remove a Stow package

```sh
stow --target "$HOME" --delete zsh
```

Do this carefully: deleting the Stow links does **not** delete the files in this repository.

## 📦 Package Management

### Fedora

The baseline is stored in:

```text
packages/fedora.txt
```

Keep this file simple: one RPM package name per line, with optional comments.

The bootstrap checks packages with `rpm -q` and installs only missing packages.

Fedora 44 uses DNF5, so the installer intentionally uses:

```sh
sudo dnf install -y package1 package2
```

without the old `--` separator before package names.

### macOS

The macOS baseline is declarative:

```text
packages/Brewfile
```

Useful commands when working on it manually:

```sh
brew bundle check --file packages/Brewfile
brew bundle --file packages/Brewfile
```

AeroSpace comes from the `nikitabobko/tap` tap. JankyBorders and SketchyBar come from the FelixKratz formula tap and are explicitly trusted in the Brewfile.

### Yazi on Fedora

Yazi is installed separately by:

```text
install/yazi.sh
```

On macOS it is a normal Homebrew package.

On Fedora, the bootstrap offers to enable the upstream-recommended Yazi COPR and install it from there. This is intentionally interactive because enabling an additional package repository is a system-level choice.

## 🐚 Shell

Zsh is shared between Fedora and macOS.

The important files live under:

```text
zsh/.config/zsh/
├── .zshrc
├── aliases.zsh
├── env.zsh
├── fzf.zsh
├── prompt.zsh
├── starship.toml
└── yazi.zsh
```

The top-level:

```text
zsh/.zshenv
```

sets up the XDG/Zsh environment early enough for both platforms.

### Environment

`env.zsh` defines the common environment, including:

- `EDITOR=nvim`
- `VISUAL=nvim`
- `~/.local/bin`
- `~/.cargo/bin`
- Apple Silicon Homebrew paths when present
- Starship configuration
- `bat` as a manual-page pager when available

### Prompt

Starship uses a compact **single-line prompt**.

Typical example:

```text
dotfiles  main +2 ❯
```

It intentionally avoids persistent noise such as hostname, username, language versions, or a second prompt line.

Slow commands can show their duration, and failed commands show their exit status.

### Yazi

Yazi intentionally has almost no shell integration:

```sh
alias y='yazi'
```

That is all.

No cwd wrapper and no custom Yazi framework. Start simple and only add configuration when something becomes annoying in daily use.

## 🧰 Terminal Workflow

The common terminal-first toolset includes:

- **Ghostty** — terminal emulator
- **Zsh** — shell
- **Starship** — prompt
- **tmux** — terminal multiplexer
- **Neovim** — editor
- **LazyGit** — Git UI
- **Yazi** — terminal file manager
- **fzf** — fuzzy finding
- **ripgrep** / **fd** — fast search
- **bat** / **eza** — nicer terminal output
- **uv / uvx** — Python tooling

The intention is for this core workflow to feel essentially identical on Fedora and macOS.

## 🧩 tmux

The configuration is managed by Stow:

```text
tmux/.config/tmux/tmux.conf
```

Plugins are managed with **TPM (tmux Plugin Manager)**.

The bootstrap installs TPM into:

```text
~/.config/tmux/plugins/tpm
```

and then asks TPM to install the plugins declared by `tmux.conf`.

The plugin directory is intentionally ignored by Git:

```text
/tmux/.config/tmux/plugins/
```

If tmux plugins ever look broken:

```sh
rm -rf ~/.config/tmux/plugins/tpm
./bootstrap
```

or reinstall them from inside tmux with TPM.

## ✏️ Neovim

Neovim is deliberately **built from source** instead of using the distribution/package-manager version.

The configured release lives in:

```text
config/neovim.env
```

Current structure:

```sh
NEOVIM_VERSION="v0.12.5"
NEOVIM_SOURCE_DIR="$HOME/.local/src/neovim"
NEOVIM_INSTALL_PREFIX="$HOME/.local"
```

To change Neovim versions, edit only:

```text
config/neovim.env
```

and rerun:

```sh
./bootstrap
```

The installer fetches tags, checks out the requested release, performs a clean Release build, and installs into:

```text
~/.local/bin/nvim
```

### Neovim configuration

The actual configuration is stowed from:

```text
nvim/.config/nvim/
```

`lazy-lock.json` is committed intentionally so plugin versions are reproducible.

### Plugins and Mason

After activating the Neovim configuration, the bootstrap can run:

```text
Lazy! sync
MasonToolsInstallSync
```

headlessly.

Some development tools intentionally belong to the workstation package layer rather than Mason. On macOS, for example, `tree-sitter-cli` and `pyright` are installed through Homebrew.

When something is wrong:

```vim
:checkhealth
:Mason
:Lazy
```

are the first places to look.

## ⌨️ Keyboard & Window-Manager Philosophy

The important rule is physical rather than platform-specific:

> **Use the second physical key left of Space as the window-manager modifier.**

That means the actual modifier can differ depending on the keyboard:

- Fedora desktop with an Apple keyboard: typically **Option / Alt**
- Fedora laptop: typically **Super / Windows**
- macOS: **Option / Alt**

The goal is identical muscle memory, not identical modifier names.

Common navigation follows Vim-style keys:

```text
h  left
j  down
k  up
l  right
```

Typical shared ideas:

| Action            | Sway                 | AeroSpace             |
| ----------------- | -------------------- | --------------------- |
| Terminal          | `$mod+Enter`         | `Alt+Enter`           |
| Close             | `$mod+Q`             | `Alt+Q`               |
| Focus             | `$mod+H/J/K/L`       | `Alt+H/J/K/L`         |
| Move              | `$mod+Shift+H/J/K/L` | `Alt+Shift+H/J/K/L`   |
| Workspace         | `$mod+1..0`          | `Alt+1..0`            |
| Move to workspace | `$mod+Shift+1..0`    | `Alt+Shift+1..0`      |
| Fullscreen        | `$mod+F`             | `Alt+F`               |
| Floating          | `$mod+T`             | `Alt+T`               |
| Resize            | `$mod+R`             | `Alt+R`               |
| Launcher          | `$mod+Space` → Wofi  | `Alt+Space` → Vicinae |

## 🐧 Fedora Desktop: Sway

The Fedora desktop layer consists of:

```text
sway/
swaync/
waybar/
wireplumber/
wofi/
```

Hyprland is no longer part of the active desktop setup.

### Machine-specific Sway configuration

Hardware-specific state is intentionally **not** stored in the repository.

The bootstrap creates:

```text
~/.config/sway-host/
├── machine.conf
└── outputs.conf
```

`machine.conf` contains the selected modifier:

```text
set $mod Mod4
```

or:

```text
set $mod Mod1
```

`outputs.conf` contains local monitor scale/layout configuration.

The main Sway config includes both files:

```text
~/.config/sway-host/machine.conf
~/.config/sway-host/outputs.conf
```

This keeps the shared Sway config portable between the Fedora desktop and laptop.

### Change the modifier later

Edit:

```sh
nvim ~/.config/sway-host/machine.conf
```

For example:

```text
set $mod Mod1
```

Then reload Sway:

```sh
swaymsg reload
```

### Change monitor configuration

Edit:

```sh
nvim ~/.config/sway-host/outputs.conf
```

Inspect outputs with:

```sh
swaymsg -t get_outputs
```

Then reload:

```sh
swaymsg reload
```

### Launcher and clipboard

Wofi is the application launcher:

```text
$mod+Space
```

Clipboard history uses `cliphist` + Wofi:

```text
$mod+Shift+V
```

### Screenshots

The Sway config uses `grim` + `slurp`.

Selected area to file:

```text
$mod+Shift+,
```

Selected area directly to clipboard:

```text
$mod+Shift+.
```

## 📊 Waybar

Waybar intentionally mirrors the information hierarchy of SketchyBar.

Conceptually:

```text
CPU  WORKSPACES  WINDOW                    NET ↓/↑  VOL  BAT  DATE/TIME
```

Network traffic includes live upload/download throughput with fixed-width formatting so the bar does not constantly shift as values change.

Useful interactions include:

- CPU → opens `btop` in Ghostty
- Volume → opens `pavucontrol`
- Clock → calendar tooltip

Waybar configuration:

```text
waybar/.config/waybar/config.jsonc
waybar/.config/waybar/style.css
```

Restart it manually with:

```sh
pkill waybar
waybar >/dev/null 2>&1 &
```

## 🔔 SwayNC

SwayNotificationCenter provides the Fedora notification center.

Configuration:

```text
swaync/.config/swaync/config.json
swaync/.config/swaync/style.css
```

It is started from the Sway session.

The styling intentionally follows the rest of the desktop: dark, compact, minimal decoration.

## 🔊 WirePlumber

The repository currently keeps:

```text
wireplumber/.config/wireplumber/wireplumber.conf.d/51-disable-suspend.conf
```

This prevents ALSA output nodes from suspending and can avoid audio wake-up delays or missing the first sound after idle.

If both Fedora machines eventually work perfectly without this workaround, this entire Stow package can be removed.

## 🍎 macOS Desktop

The macOS desktop is built around:

- **AeroSpace** — tiling window manager
- **SketchyBar** — status bar
- **JankyBorders** — active-window border
- **Vicinae** — launcher
- **Ghostty** — terminal

The intent is a fast, keyboard-driven environment that feels closer to Sway than to the default macOS desktop.

### AeroSpace

Configuration:

```text
aerospace/.config/aerospace/aerospace.toml
```

The current config includes:

- Vim-style focus and movement
- workspaces `1..0`
- resize mode
- floating toggle
- small gaps
- Firefox routing to workspace 9
- Thunderbird routing to workspace 8
- Finder floating

Reload after changes:

```sh
aerospace reload-config
```

### Find an application bundle ID

For the focused window:

```sh
aerospace list-windows --focused \
  --format '%{app-bundle-id}'
```

For more context:

```sh
aerospace list-windows --focused \
  --format 'app=%{app-name} id=%{app-bundle-id} title=%{window-title}'
```

This is useful when adding `on-window-detected` rules.

## 📊 SketchyBar

SketchyBar is the macOS counterpart to Waybar.

Its layout is intentionally notch-safe: application context is kept next to the workspaces rather than centered underneath the MacBook camera area.

Conceptually:

```text
CPU  1 2 3 4 5 6 7 8 9 0  APP              NET ↓/↑  VOL  BAT  DATE/TIME
```

Configuration:

```text
sketchybar/.config/sketchybar/
```

AeroSpace notifies SketchyBar about workspace changes through `exec-on-workspace-change`, so workspace highlighting is event-driven instead of constantly polled.

Network throughput is calculated from macOS interface byte counters and uses fixed-width fields to prevent layout jumping.

Reload:

```sh
sketchybar --reload
```

Debug interactively:

```sh
brew services stop sketchybar
sketchybar
```

Start it again:

```sh
brew services start sketchybar
```

## 🟦 JankyBorders

JankyBorders draws the active-window border on macOS.

Configuration:

```text
borders/.config/borders/bordersrc
```

The bootstrap can start it as a user Homebrew service.

Useful commands:

```sh
brew services list
brew services restart borders
```

## ⚡ macOS Defaults

The bootstrap can apply the preferences in:

```text
install/macos-defaults.sh
```

Current goals include:

- fast key repeat
- short repeat delay
- empty auto-hidden Dock
- no Dock reveal delay
- reduced Dock/Mission Control animations
- no recent apps in Dock
- stable Spaces ordering
- hidden Apple menu bar
- reduced Finder/general UI animations
- screenshots in `~/Screenshots`
- screenshot shadows disabled

These settings are deliberately limited to useful, understandable preferences.

A few visual settings remain manual because macOS changes their internals frequently. In particular, the wallpaper is intentionally configured manually.

## 🛠 Personal Scripts

Personal scripts are **not** Stowed as one giant `~/.local/bin` directory.

Instead, `install/scripts.sh` links individual scripts into:

```text
~/.local/bin
```

This avoids owning the entire directory and prevents collisions with binaries installed by other tools.

Current groups:

```text
scripts/common/
scripts/linux/
scripts/macos/
```

Common scripts are installed everywhere. Linux/macOS scripts are only linked on their target platform.

If a target already exists and is not managed by this repository, the installer leaves it alone.

### Important cleanup note

There are still some old Linux helper names in the repository, including a Hyprland-related monitor helper. Hyprland itself is no longer part of the active desktop configuration. Treat such scripts as candidates for future cleanup rather than part of the core workstation model.

## 🔄 Updating a Machine

The normal update flow should stay boring:

```sh
cd ~/workspace/dotfiles
git pull
./bootstrap
```

Then reload only what changed.

Shell:

```sh
exec zsh
```

Sway:

```sh
swaymsg reload
```

AeroSpace:

```sh
aerospace reload-config
```

SketchyBar:

```sh
sketchybar --reload
```

Waybar:

```sh
pkill waybar
waybar >/dev/null 2>&1 &
```

For package changes, simply rerun `./bootstrap`; the installers check what is already present.

## 🧪 Safe Migration from an Older Dotfiles Repository

Do not blindly delete old symlinks.

First inspect them:

```sh
readlink ~/.config/zsh
readlink ~/.config/nvim
readlink ~/.config/tmux
```

If an old repository owns a Stow package, preview removing it from the **old repository**:

```sh
stow \
  --dir ~/workspace/old-dotfiles \
  --target "$HOME" \
  --delete \
  --simulate \
  --verbose=1 \
  zsh
```

If the preview is correct, run it again without `--simulate`.

Then rerun:

```sh
./bootstrap
```

The new bootstrap will refuse to overwrite conflicting files and will tell you which package needs manual migration.

## 🩺 Troubleshooting

### Bootstrap stopped

Rerun:

```sh
./bootstrap
```

The scripts are designed to be rerunnable. Already-installed packages and already-active components are detected where possible.

### Stow says a package cannot be activated

Inspect the output carefully. Usually an existing file or symlink is owned by an older dotfiles repository.

Check:

```sh
ls -la ~/.config/<name>
readlink ~/.config/<name>
```

Do not use `stow --adopt` casually. The migration policy of this repository is to avoid silently taking ownership of existing files.

### Zsh configuration looks stale

```sh
exec zsh
```

Also verify:

```sh
echo "$ZDOTDIR"
echo "$XDG_CONFIG_HOME"
```

### Neovim version is wrong

Check:

```sh
which nvim
nvim --version | head -n 1
cat config/neovim.env
```

The expected binary is normally:

```text
~/.local/bin/nvim
```

### Neovim plugins/tools are broken

Inside Neovim:

```vim
:checkhealth
:Lazy
:Mason
```

Then rerun:

```sh
./bootstrap
```

### tmux plugins are missing

Check:

```sh
ls ~/.config/tmux/plugins/tpm
```

Then rerun the bootstrap or reinstall TPM.

### Sway modifier is wrong

Edit:

```sh
nvim ~/.config/sway-host/machine.conf
swaymsg reload
```

### Sway monitor layout is wrong

```sh
swaymsg -t get_outputs
nvim ~/.config/sway-host/outputs.conf
swaymsg reload
```

### SketchyBar is acting strangely

```sh
brew services stop sketchybar
sketchybar
```

Run it in the foreground and inspect errors.

### AeroSpace rule needs an app ID

```sh
aerospace list-windows --focused \
  --format '%{app-bundle-id}'
```

### Where did this command come from?

```sh
command -v <command>
```

On Fedora, find the owning RPM:

```sh
rpm -qf "$(command -v <command>)"
```

This is useful for compatibility packages such as `wget2-wget`, where the command name and RPM package name differ.

## 🧹 Adding Something New

Before adding a new tool, decide where ownership belongs.

### New cross-platform CLI

Add it to:

```text
packages/fedora.txt
packages/Brewfile
```

If the package names or installation methods differ substantially, create a small explicit installer under `install/`.

### New macOS application

Usually add it to:

```text
packages/Brewfile
```

Prefer Homebrew Casks when practical.

### New Fedora desktop package

Add it to:

```text
packages/fedora.txt
```

### New dotfile package

Create a Stow-compatible directory:

```text
tool/
└── .config/
    └── tool/
        └── config
```

Then add:

```sh
stow_package tool
```

to the appropriate platform section in `install/common.sh`.

### New personal script

Put it in one of:

```text
scripts/common/
scripts/linux/
scripts/macos/
```

Make it executable and add its name to the corresponding array in:

```text
install/scripts.sh
```

Do **not** turn the entire `~/.local/bin` directory into a Stow package.

## 🧠 Future Me: Read This First

If it has been three months and none of this looks familiar:

1. **Run `git pull && ./bootstrap`.**
2. The bootstrap is meant to be rerunnable.
3. **GNU Stow owns the dotfile symlinks.**
4. `install/common.sh` decides which Stow packages are active.
5. Fedora packages live in `packages/fedora.txt`.
6. macOS packages live in `packages/Brewfile`.
7. The Neovim version lives in `config/neovim.env`.
8. Neovim is built into `~/.local`, not installed from DNF/Homebrew.
9. Fedora machine-specific Sway settings live in `~/.config/sway-host/` and are intentionally not in Git.
10. `y` is just an alias for `yazi`. There is no magic cwd wrapper.
11. Personal scripts are linked individually into `~/.local/bin`.
12. AeroSpace and Sway intentionally share similar key concepts, but they are not forced into identical configuration syntax.
13. Wallpaper and a few fragile macOS visual preferences are intentionally manual.
14. If Stow detects a conflict, **do not force it**. Find out who owns the existing file first.
15. If something works well, resist the urge to add another configuration framework.

Most importantly:

> **Prefer boring, understandable shell scripts over clever abstractions.**

That is the architecture.

## ✅ Fresh-Machine Checklist

When setting up a new machine:

### Fedora

```text
[ ] Clone repository
[ ] Run ./bootstrap
[ ] Install missing DNF packages
[ ] Activate common Stow packages
[ ] Build Neovim
[ ] Install Mason tools
[ ] Choose Sway modifier
[ ] Adjust ~/.config/sway-host/outputs.conf
[ ] Confirm Waybar / SwayNC / Wofi
[ ] Confirm personal scripts
[ ] Logout/login if needed
```

### macOS

```text
[ ] Clone repository
[ ] Run ./bootstrap
[ ] Install/update Homebrew when prompted
[ ] Install Brewfile
[ ] Confirm /bin/zsh login shell
[ ] Activate common Stow packages
[ ] Build Neovim
[ ] Install Mason tools
[ ] Activate AeroSpace
[ ] Activate JankyBorders
[ ] Activate SketchyBar
[ ] Apply macOS defaults
[ ] Set wallpaper manually
[ ] Enable the desired solid menu-bar background manually if needed
[ ] Logout/login
```

After that, open Ghostty, start tmux, run Neovim, press the window-manager keys a few times, and the machine should feel familiar again.

## ❤️ Why This Exists

The point of this repository is not perfect automation.

It is to make a fresh Fedora machine or Mac feel like **my workstation** again without having to remember dozens of package names, symlink commands, shell tweaks, editor build steps, or desktop settings.

Small. Safe. Reproducible enough. Easy to understand.
