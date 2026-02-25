vim.opt_local.wrap = true      -- Enable soft wrap
vim.opt_local.linebreak = true -- Make sure that words are not wrapped
vim.opt_local.textwidth = 0    -- no automatic line wrapping
vim.opt_local.colorcolumn = "" -- Visual indication of break

vim.opt_local.spell = true
vim.opt_local.spelllang = { "de", "en" }

-- Optical reduction
vim.opt.list = true
vim.opt.listchars:append({ eol = "↵" })
vim.opt.fillchars:append({ eob = " " })

vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
