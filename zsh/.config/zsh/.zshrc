# Make sure that umlauts are correctly displayed (e.g. Mutt)
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Get target platform (e.g. linux or macOS)
platform=`uname`

# Enable completion
autoload -U compinit
compinit

# Disable flow control commands (keeps C-s from freezing everything)
stty start undef
stty stop undef

export EDITOR="nvim"

# Setup XDG
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache

# Save history
HISTSIZE=20000
HISTFILE=$XDG_DATA_HOME/zsh/history
SAVEHIST=20000

if [[ $platform == 'Darwin' ]]; then
    export SHELL=/bin/zsh
else
    export SHELL=/usr/bin/zsh
fi

export GOPATH=$HOME/workspace/go

export PATH="$HOME/.local/bin:/opt/homebrew/bin:$GOPATH/bin:$PATH"
export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/opt/homebrew/lib

# Path for dynamically loading libraries
export DYLD_LIBRARY_PATH=/opt/homebrew/lib:$DYLD_LIBRARY_PATH

# Enable VIM mode
bindkey -v

# Enable backward search and some other nice bindings
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line


# Aliases
if [[ $platform == 'Linux' ]]; then
  alias ls='ls -lhG --color'
elif [[ $platform == 'Darwin' ]]; then
  alias ls='ls -lhG'
fi

alias p='python3'
alias xxx='source $XDG_CONFIG_HOME/zsh/.zshrc'
alias gd='git difftool --extcmd "icdiff -N"'
alias l='ls -laG'
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"
alias ..='cd ..'

alias gg="git log --graph --full-history --all --color --pretty=format:'%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s (%ar) [%an]'"
alias ggg='git pull -r'
alias gp='git push'
alias g='git status'
alias lg=lazygit

# Review all open INBOX notes from Obsidian
alias or='nvim $HOME/notes/INBOX/*.md'

if [[ $platform == 'Darwin' ]]; then
    alias vi='/opt/homebrew/bin/nvim'
else
    alias vi='/usr/local/bin/nvim'
fi

# Setup prompt
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'M'
zstyle ':vcs_info:*' unstagedstr 'M'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
  '%F{5}[%F{2}%b%F{5}] %F{2}%c%F{3}%u%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git
+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
    git status --porcelain | grep '??' &> /dev/null ; then
    hook_com[unstaged]+='%F{1}??%f'
  fi
}

precmd () { vcs_info }
PROMPT='%F{5}[%F{2}%m@%n%F{5}] %F{3}%3~ ${vcs_info_msg_0_}%f> '

# Enable fuzzy finder
if [[ $platform == 'Linux' ]]; then
    # Activate FZF fuzzy finder
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
