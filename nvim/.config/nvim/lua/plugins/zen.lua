return {
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          backdrop = 0.2,
          width = 100,
          options = {
            signcolumn = "no",
            number = false,
            cursorline = false,
          },
        },
        plugins = {
          options = { enabled = true, ruler = false, showcmd = false },
        },
      })
    end,
  },
}
