return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim', build = 'make'
      }
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            theme = "ivy"
          },
          buffers = {
            theme = "ivy",
            sort_mru = true,
            ignore_current_buffer = true
          },
        },

        extensions = {
          fzf = {}
        }
      }

      local builtin = require('telescope.builtin')

      require('telescope').load_extension('fzf')

      vim.keymap.set("n", "<space>fh", builtin.help_tags)
      vim.keymap.set("n", "<space>ff", builtin.find_files)
      vim.keymap.set("n", "<leader><Esc>", builtin.buffers)
      vim.keymap.set("n", "<space>en", function()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)
    end
  }
}
