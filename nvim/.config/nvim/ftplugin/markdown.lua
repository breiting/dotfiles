vim.opt_local.wrap = true
vim.opt_local.linebreak = true

-- See here: https://github.com/epwalsh/obsidian.nvim/issues/286
vim.opt_local.conceallevel = 1

vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
