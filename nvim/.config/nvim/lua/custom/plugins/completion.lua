return {
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<C-CR>'] = { 'accept', 'fallback' },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      signature = { enabled = true },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- Disable completion for text files and prompts
      enabled = function()
        return not vim.tbl_contains({ "markdown" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
      end
    },
  },
}
