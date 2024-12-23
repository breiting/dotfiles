return {
  {
    "folke/tokyonight.nvim",
    enabled = true,
    config = function()
      require('tokyonight').setup({
        lazy = false,
        priority = 1000,
      })
      vim.cmd.colorscheme 'tokyonight-moon'
    end
  }
}
