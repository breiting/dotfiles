return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      renderer = {
        icons = {
          git_placement = "after",
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
          }
        }
      }
    }
  end,
}
