return {
  {
    dir = "~/workspace/zettel.nvim/",
    enabled = true,
    name = "zettel",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("zettel").setup({
        vault_dir = "~/zettel",
      })
    end,
  },
}
