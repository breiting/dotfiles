return {
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters = {
          prettier_safe_md = {
            command = vim.fn.expand("$HOME/.local/bin/prettier-safe-md"),
            stdin = true,
          },
        },
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier_safe_md" },
          lua = { "stylua" },
        },
        format_on_save = {
          lsp_fallback = true,
          timeout_ms = 500,
        },
      })
    end,
  },
}
