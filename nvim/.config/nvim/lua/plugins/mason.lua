-- https://www.andersevenrud.net/neovim.github.io/lsp/configurations/
return {
  {
    "williamboman/mason.nvim", -- Package manager for LSP and linters
    config = function()
      require("mason").setup({})
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        -- a list of all tools you want to ensure are installed upon start
        ensure_installed = {

          "gopls",
          "clang-format",
          "json-lsp",
          "lua-language-server",
          "pyright",
          "ruff",
          "shfmt",
          "stylua",
          "codelldb",
        },

        auto_update = false,
        run_on_start = true,
      })
    end,
  },
}
