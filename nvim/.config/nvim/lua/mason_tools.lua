-- Tools that are primarily owned by Neovim and installed through Mason.
--
-- Workstation-level tools such as tree-sitter-cli are intentionally absent.
-- Pyright is installed by Homebrew on macOS because Mason's npm-based
-- installation has proven unreliable there; Fedora continues to use Mason.

local tools = {
    "gopls",
    "json-lsp",
    "lua-language-server",
    "neocmakelsp",
    "prettier",
    "ruff",
    "shfmt",
    "typstyle",
}

if vim.fn.has("mac") == 0 then
    table.insert(tools, "pyright")
end

return tools
