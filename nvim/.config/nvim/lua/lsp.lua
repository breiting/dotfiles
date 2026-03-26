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
        "requirements.txt"
    },
    capabilities = capabilities,
    settings = {
        pyright = {
            disableOrganizeImports = true,
            disableLanguageServices = false,
        },
        python = {
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
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
