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
vim.opt.signcolumn = 'yes'
vim.opt.wrap = false

-- Global Keymaps
vim.keymap.set("n", "<Esc>", function()
  vim.cmd('nohlsearch')
end, { desc = "Clear search highlights", silent = true })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open the parent directory" })
vim.keymap.set("n", "<leader>t", "<CMD>NvimTreeToggle<CR>")

-- Background transparent
vim.cmd [[
  highlight Normal guibg=none ctermbg=none
  highlight NonText guibg=none ctermbg=none
  highlight SignColumn guibg=none
]]
