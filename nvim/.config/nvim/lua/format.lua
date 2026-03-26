-- Format current buffer with an external formatter and replace buffer contents
local function format_with(cmd, args, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local text = table.concat(lines, "\n")

    local result = vim.system(
        vim.list_extend({ cmd }, args or {}),
        { text = true, stdin = text }
    ):wait()

    if result.code ~= 0 then
        vim.notify(
            (result.stderr ~= "" and result.stderr) or ("Formatter failed: " .. cmd),
            vim.log.levels.WARN
        )
        return false
    end

    local output = result.stdout or ""

    -- Keep trailing newline behavior stable
    if output:sub(-1) == "\n" then
        output = output:sub(1, -2)
    end

    local new_lines = vim.split(output, "\n", { plain = true })

    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
    vim.fn.winrestview(view)

    return true
end

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local name = vim.api.nvim_buf_get_name(args.buf)

        local prettier_fts = {
            javascript = true,
            typescript = true,
            javascriptreact = true,
            typescriptreact = true,
            html = true,
            css = true,
            scss = true,
            json = true,
            jsonc = true,
            yaml = true,
            markdown = true,
        }

        if prettier_fts[ft] then
            format_with("prettier", { "--stdin-filepath", name }, args.buf)
            return
        end

        if ft == "typst" then
            format_with("typstyle", {}, args.buf)
            return
        end

        vim.lsp.buf.format({
            bufnr = args.buf,
            timeout_ms = 1500,
            filter = function(client)
                if ft == "python" then
                    return client.name == "ruff"
                end
                return client.name ~= "pyright"
            end,
        })
    end,
})
