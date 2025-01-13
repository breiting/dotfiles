-- Global keymaps for better default experience

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Navigate to the parent folder with oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Convenience function for toggle a checkbox line (useful for Obsidian)
function Toggle_CheckBox()
  -- Get the current line
  local line = vim.api.nvim_get_current_line()

  -- Check if line contains unchecked checkbox
  if line:match("^%s*-%s*%[ %]") then
    -- Replace unchecked with checked
    local new_line = line:gsub("%[ %]", "[x]")
    vim.api.nvim_set_current_line(new_line)

    -- Check if line contains checked checkbox
  elseif line:match("^%s*-%s*%[x%]") then
    -- Replace checked with unchecked
    local new_line = line:gsub("%[x%]", "[ ]")
    vim.api.nvim_set_current_line(new_line)

    -- If no checkbox, do nothing
  else
    print("No checkbox found on this line")
  end
end

vim.keymap.set("n", "<leader>tt", Toggle_CheckBox, { noremap = true, silent = true })
