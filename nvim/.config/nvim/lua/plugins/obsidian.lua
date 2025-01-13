return {
  "epwalsh/obsidian.nvim",
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
        name = "notion",
        path = "~/notion",
      },
    },

    daily_notes = {
      folder = "Journal",
      date_format = "%Y-%m-%d",
    },

    disable_frontmatter = true,

    attachments = {
      img_folder = "assets",
    },

    completion = {
      nvim_cmp = true,
      min_char = 2,
    },
  },
}
