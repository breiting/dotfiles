local M = {}

-- Replace "" to <> for include statements
function M.replace_includes()
  -- Visual marking
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local bufnr = 0
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[2] - 1, end_pos[2], false)

  -- replace all lines
  for i, line in ipairs(lines) do
    -- only #include "..."
    local new_line = line:gsub('#include%s+"(.-)"', "#include <%1>")
    lines[i] = new_line
  end

  -- write back
  vim.api.nvim_buf_set_lines(bufnr, start_pos[2] - 1, end_pos[2], false, lines)
end

return M
