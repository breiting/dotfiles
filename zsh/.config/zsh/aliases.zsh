# Prefer modern replacements when they are installed.
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons'
    alias l='eza -lah --icons --git'
    alias tree='eza --tree --icons'
    compdef eza=ls
fi

if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
fi

# Core utilities
alias df='df -h'
alias -- -='cd -'

# Editor
alias vi='nvim'

# Git
alias g='git status'
alias gp='git push'
alias ggg='git pull -r'
alias lg='lazygit'
alias gg="git log --graph --full-history --all --color --pretty=format:'%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s (%ar) [%an]'"

# Shell helpers
alias reload='exec zsh'
alias venv='source .venv/bin/activate'
