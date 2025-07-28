return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },

    config = function()
      require("render-markdown").setup({
        completions = {
          lsp = {
            enabled = true,
          },
        },
      })
    end,
  },
}
