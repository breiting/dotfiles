local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("clangd", {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = {
        "compile_commands.json",
        "compile_flags.txt",
        ".clangd",
    },
    capabilities = capabilities,
})

vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_markers = { "go.mod" },
    capabilities = capabilities,
    settings = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
})

vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc"
    },
    capabilities = capabilities,
    settings = {
        Lua = {
            format = { enable = true },
            diagnostics = {
                globals = { "vim" },
            },
            hint = { enable = true },
            workspace = {
                checkThirdParty = false,
            },
        },
    },
})


vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "pyrightconfig.json",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
    },
    capabilities = capabilities,
    settings = {
        pyright = {
            disableOrganizeImports = true, -- Let Ruff handle imports
            disableTaggedHints = true,     -- Hide faded/struck hint diagnostics
        },
        python = {
            analysis = {
                typeCheckingMode = "basic",         -- Keep Pyright focused on types
                diagnosticMode = "openFilesOnly",   -- Only report diagnostics for open files
                autoImportCompletions = true,       -- Keep import completion
                autoSearchPaths = true,             -- Auto-detect common source roots
                useLibraryCodeForTypes = true,      -- Improve library typing when stubs are incomplete
                diagnosticSeverityOverrides = {
                    reportUnusedImport = "none",    -- Ruff handles this
                    reportUnusedVariable = "none",  -- Ruff handles this
                    reportDuplicateImport = "none", -- Ruff handles this
                    reportImportCycles = "none",    -- Optional: reduce Pyright noise
                    reportShadowedImports = "none", -- Ruff handles import hygiene better
                },
            },
        },
    },
})

vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "ruff.toml",
        ".ruff.toml",
        "setup.py",
        "setup.cfg",
        ".git",
    },
    capabilities = capabilities,
})

vim.lsp.config("neocmakelsp", {
    cmd = { "ruff", "--stdio" },
    filetypes = { "cmake" },
    root_markers = {
        "build",
        "cmake",
        ".git",
    },
    capabilities = capabilities,
})

vim.lsp.enable("clangd")
vim.lsp.enable("gopls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("neocmakelsp")

-- LSP configuration stuff

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

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
        end
    end,
})
