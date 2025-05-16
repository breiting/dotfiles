-- https://microsoft.github.io/pyright/#/
return {
  cmd = { "pyright-langserver", "--stdio" },
  root_markers = { "pyproject.toml", "setup.cfg", "pyrightconfig.json" },
  filetypes = { "python" },
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        -- logLevel = "Information",
      },
    },
    pyright = {
      disableOrganizeImports = true,
      disableLanguageServices = false,
    },
  },
}
