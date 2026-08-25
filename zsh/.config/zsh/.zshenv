# XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Preferred editor
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Personal binaries
path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    $path
)

# Homebrew is installed below /opt/homebrew on Apple Silicon.
if [[ -d /opt/homebrew/bin ]]; then
    path=(
        /opt/homebrew/bin
        /opt/homebrew/sbin
        $path
    )
fi

# Avoid duplicate PATH entries while preserving their order.
typeset -U path PATH

# Keep Starship configuration with the rest of the Zsh configuration.
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"

# bat makes a useful manual-page pager when available.
if command -v bat >/dev/null 2>&1; then
    export MANPAGER="bat -l man -p"
fi

# GPG needs the current terminal only for interactive shells.
if [[ -t 0 ]]; then
    export GPG_TTY="$(tty)"
fi
