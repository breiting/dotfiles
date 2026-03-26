-- Global config

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

local opt = vim.opt

opt.backup = false -- Disable backup files
opt.swapfile = false -- Disable swap files
opt.undofile = true -- Enable persistent undo
opt.confirm = true -- Ask for confirmation instead of failing

opt.clipboard = "unnamedplus" -- Use system clipboard
opt.mouse = "a" -- Enable mouse support

opt.number = true -- Show absolute line numbers
opt.relativenumber = true -- Show relative line numbers
opt.signcolumn = "yes" -- Always show the sign column
opt.cursorline = true -- Highlight the current line
opt.scrolloff = 4 -- Keep context above and below cursor

opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Override ignorecase if search has capitals
opt.inccommand = "split" -- Preview substitutions in a split

opt.splitright = true -- Open vertical splits to the right
opt.splitbelow = true -- Open horizontal splits below

opt.updatetime = 250 -- Reduce update delay
opt.timeoutlen = 300 -- Reduce mapped sequence timeout

opt.expandtab = true -- Convert tabs to spaces
opt.tabstop = 4 -- Display a tab as 4 spaces
opt.shiftwidth = 4 -- Use 4 spaces for indentation
opt.softtabstop = 4 -- Use 4 spaces while editing tabs
opt.smartindent = true -- Enable smart auto-indentation
opt.breakindent = true -- Preserve indentation on wrapped lines

opt.wrap = false -- Disable line wrapping by default
opt.linebreak = true -- Wrap on word boundaries when wrap is enabled

opt.list = true -- Show invisible characters
opt.listchars = { -- Define symbols for invisible characters
    tab = "» ", -- Show tabs with a visible marker
    trail = "·", -- Show trailing spaces
    nbsp = "␣", -- Show non-breaking spaces
}

opt.colorcolumn = "120"   -- Highlight column 120
opt.termguicolors = true  -- Enable true color support
opt.showmode = false      -- Hide mode since statusline shows it
opt.winborder = "rounded" -- Use rounded borders for floating windows

-- Diagnostic settings

vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = {
        spacing = 2,
        source = "if_many",
    },
    float = {
        border = "rounded",
        source = "if_many",
    },
})

-- Keymapping

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save current buffer" })

map("n", "<C-h>", "<C-w>h", { desc = "Left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Right window" })

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Autocommands

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "typst" },
    callback = function(event)
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.textwidth = 0
        vim.opt_local.colorcolumn = ""
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { "de", "en" }

        vim.keymap.set("n", "j", "gj", { buffer = event.buf, silent = true })
        vim.keymap.set("n", "k", "gk", { buffer = event.buf, silent = true })
    end,
})

-- LSP stuff

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local mapl = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
        end

        mapl("n", "gd", vim.lsp.buf.definition, "Definition")
        mapl("n", "gr", vim.lsp.buf.references, "References")
        mapl("n", "gi", vim.lsp.buf.implementation, "Implementation")
        mapl("n", "K", vim.lsp.buf.hover, "Hover")
        mapl("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        mapl({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        mapl("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, "Format buffer")
        mapl("n", "<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
        end, "Toggle inlay hints")
    end,
})
