# Neovim

Shared Neovim 0.12.x configuration for Fedora Linux and macOS.

This first migration deliberately keeps the existing editor recognizable rather
than replacing it with a framework or a large rewrite.

## Migration changes

- `nvim` is an explicit Stow package.
- `vim-tmux-navigator` is enabled on the Neovim side; the old direct
  `Ctrl-h/j/k/l` split mappings are removed.
- Tinymist uses the Neovim 0.12 `vim.lsp.config()` API correctly and is enabled.
- The local `~/workspace/zettel.nvim` plugin is enabled only when that checkout
  exists, so a fresh Mac does not fail because the personal plugin is absent.
- Mason Tool Installer no longer installs tools automatically on every editor
  startup. Tools remain explicitly installable while tool ownership is cleaned
  up in a later step.
- External formatters are checked before execution.

## Cleanup candidates

After this version is proven on Fedora and macOS, review these separately:

- Mason vs workstation-bootstrap ownership of developer tools.
- Hard-coded personal paths.
- Formatter ownership and format-on-save policy.
- Plugin-file splitting only where it improves navigation.
