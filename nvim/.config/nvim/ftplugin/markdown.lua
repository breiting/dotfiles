vim.opt_local.wrap = true         -- Enable soft wrap
vim.opt_local.linebreak = true    -- Make sure that words are not wrapped
vim.opt_local.textwidth = 100
vim.opt_local.colorcolumn = "100" -- Visual indication of break

vim.opt_local.spell = true
vim.opt_local.spelllang = { "de" }

-- See here: https://github.com/epwalsh/obsidian.nvim/issues/286
vim.opt_local.conceallevel = 1

vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
