-- Global settings

vim.g.have_nerd_font = true
vim.opt.backup = false            -- Do not use backup files
vim.opt.breakindent = true        -- Enable break indent
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and neovim
vim.opt.colorcolumn = "120"       -- Show colorcolumn
vim.opt.cursorline = true         -- Show which line your cursor is on
vim.opt.ignorecase = true         -- Case-insensitive searching
vim.opt.inccommand = "split"      -- Preview substitutions live, as you type!
vim.opt.list = true               -- Show list symbols
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.mouse = "a"               -- Enable mouse mode
vim.opt.number = true             -- Make line numbers default
vim.opt.relativenumber = true     -- Set relative numbering
vim.opt.scrolloff = 4             -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.shiftwidth = 4            -- Shift width
vim.opt.showmode = false          -- Don't show the mode
vim.opt.signcolumn = "yes"        -- Keep signcolumn on by default
vim.opt.smartcase = true          -- Smart case
vim.opt.softtabstop = 4           -- Tab stop
vim.opt.splitbelow = true         -- Default split
vim.opt.splitright = true         -- Default split
vim.opt.swapfile = false          -- Do not use swap files
vim.opt.tabstop = 4               -- Set tabstop
vim.opt.timeoutlen = 300          -- Decrease mapped sequence wait time
vim.opt.updatetime = 250          -- Decrease update time
vim.opt.wrap = false              -- Display lines as long as necessary

--- LaTeX
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_general_viewer = "open"
