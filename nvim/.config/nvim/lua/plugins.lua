local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Use Mason to install all LSPs automatically
    {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
        opts = {},
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "clangd",
                "gopls",
                "json-lsp",
                "lua-language-server",
                "neocmakelsp",
                "prettier",
                "pyright",
                "ruff",
                "shfmt",
                "typstyle",
            },
            run_on_start = true,
        },
    },
    {
        "stevearc/oil.nvim",
        lazy = false,
        cmd = "Oil",
        opts = {
            default_file_explorer = true,
            delete_to_trash = false,
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = false,
            },
            float = {
                padding = 2,
                max_width = 0,
                max_height = 0,
                border = "rounded",
            },
        },
    },

    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        lazy = false,
        opts = {
            enabled = function()
                local disabled = { markdown = true, typst = true }
                return not disabled[vim.bo.filetype]
            end,
            keymap = {
                preset = "default",
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                documentation = {
                    auto_show = false,
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            signature = {
                enabled = true,
            },
            fuzzy = {
                implementation = "prefer_rust_with_warning",
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "go",
                "gomod",
                "gosum",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "vim",
                "vimdoc",
                "yaml",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs_staged_enable = false,
            current_line_blame = false,
        },
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        init = function()
            vim.cmd.colorscheme("tokyonight-night")
            vim.cmd.hi("Comment gui=none")
        end,
    },
    -- Highlight todo, notes, etc in comments
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    {
        "echasnovski/mini.nvim",
        config = function()
            require("mini.ai").setup({ n_lines = 500 })
            require("mini.surround").setup()
            local statusline = require("mini.statusline")
            statusline.setup({ use_icons = vim.g.have_nerd_font })
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return "%2l:%-2v"
            end
        end,
    },
    {
        "breiting/zettel.nvim",
        enabled = true,
        name = "zettel",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("zettel").setup({
                vault_dir = "~/notes",
                note_types = { "note", "capture", "meeting", "mutig", "blog", "journal", "view", "meta" },
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "Find files",
            },
            {
                "<leader>ss",
                function()
                    require("telescope.builtin").live_grep()
                end,
                desc = "Live grep",
            },
            {
                "<leader><Esc>",
                function()
                    require("telescope.builtin").buffers({
                        sort_mru = true,
                        ignore_current_buffer = true,
                    })
                end,
                desc = "Buffers",
            },
            {
                "<leader>sw",
                function()
                    require("telescope.builtin").grep_string()
                end,
                desc = "Word under cursor",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        opts = {
            defaults = {
                layout_strategy = "vertical",
                layout_config = {
                    vertical = { width = 0.8 },
                },
            },
            pickers = {
                find_files = {
                    theme = "dropdown",
                },
                buffers = {
                    theme = "dropdown",
                },
            },
        },
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            pcall(telescope.load_extension, "fzf")
        end,
    }
}, {
    change_detection = { notify = false },
    checker = { enabled = false },
})
