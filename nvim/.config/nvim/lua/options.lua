-- Global settings
--
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.clipboard = 'unnamedplus'
-- vim.opt.guicursor = '' -- really?
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 4
vim.opt.listchars = 'tab:> ,trail:·'
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = '120'
vim.opt.cursorline = true

-- Global Keymaps
vim.keymap.set("n", "<Esc>", function()
  vim.cmd('nohlsearch')
end, { desc = "Clear search highlights", silent = true })

-- Background transparent
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
