return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/notes",
        },
        {
          name = "mmi",
          path = "~/mmi",
        },
      },

      completion = {
        blink = true,
        min_chars = 2,
      },

      -- daily_notes = {
      --   folder = "Journal",
      --   date_format = "%Y-%m-%d",
      -- },
      --
      disable_frontmatter = true,

      attachments = {
        img_folder = "assets",
      },

      -- disable markdown rendering
      ui = {
        enable = false,
      },
    },
  },
}
