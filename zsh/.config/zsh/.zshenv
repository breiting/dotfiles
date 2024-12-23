if [ -d "$HOME/.config/zsh/.zshenv.d" ]; then
  for EXTENSION_FILE in $(find $HOME/.config/zsh/.zshenv.d/ -name '*.zsh'); do
    source "$EXTENSION_FILE"
  done
fi
