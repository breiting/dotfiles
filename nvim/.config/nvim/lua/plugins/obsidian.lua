return {
  {
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
          name = "book",
          path = "~/workspace/book-mmi/zettelkasten",
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

      -- disable markdown rendering
      ui = {
        enable = false,
      },
    },
  },
}
