-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "EdenEast/nightfox.nvim",
        config = function()
            vim.cmd.colorscheme("carbonfox")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "ocaml",
                    "javascript", "markdown", "menhir", "python", "typescript", "sql", "jinja", "rust", "json", "circom",
                    "bash" },
                highlight = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<Leader>ss",
                        node_incremental = "<Leader>si",
                        scope_incremental = "<Leader>sc",
                        node_decremental = "<Leader>sd",
                    },
                },
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim", "stevearc/oil.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            local oil = require("oil")
            local map_absolute = function(bind, func, desc)
                vim.keymap.set("n", bind, function()
                        local active_clients = vim.lsp.get_clients()
                        if active_clients[1] ~= nil then
                            return func({ cwd = active_clients[1].config.root_dir })
                        end
                        return func()
                    end,
                    { desc = desc })
            end
            local map_relative = function(bind, func, desc)
                vim.keymap.set("n", bind, function()
                        local path = vim.fn.expand("%:p:h")
                        if path:match("^oil://") then
                            path = oil.get_current_dir()
                        end
                        return func({ cwd = path })
                    end,
                    { desc = desc }
                )
            end
            map_absolute("<leader>sf", builtin.find_files, "[S]earch [F]iles")
            map_absolute("<leader>gf", builtin.live_grep, "[G]rep from [F]iles")
            map_relative("<leader>sr", builtin.find_files, "[S]earch Files [R]elative to directory")
            map_relative("<leader>gr", builtin.live_grep, "[G]rep from files [R]elative to directory")
            vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers" })
            vim.keymap.set("n", "<leader>st", builtin.filetypes, { desc = "[S]earch File[t]ypes" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>/", function()
                builtin.current_buffer_fuzzy_find(
                    require("telescope.themes")
                    .get_dropdown({ previewer = false, winblend = 10, }))
            end, { desc = "Search current buffer" })
        end,
    },
    {
        "williamboman/mason.nvim",
        version = "1.11.0",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        version = "1.32.0",
        dependencies = { "mason.nvim" },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "nvim-telescope/telescope.nvim"
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    -- Delete some default keybinds, set omnifunc
                    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
                    vim.keymap.del("n", "K", { buffer = args.buf })
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local map = function(mode, bind, func, cond)
                        if client ~= nil and client.supports_method(cond) then
                            vim.keymap.set(mode, bind, func, { buffer = args.buf })
                        else
                            vim.keymap.set(mode, bind, function()
                                    vim.notify(cond .. " LSP feature is not supported")
                                end,
                                { buffer = args.buf })
                        end
                    end
                    local builtin = require("telescope.builtin")
                    if client.config.root_dir ~= nil then
                        vim.keymap.set("n", "<leader>sf", function()
                            return builtin.find_files({ cwd = client.config.root_dir })
                        end, { buffer = args.buf })
                        vim.keymap.set("n", "<leader>gf", function()
                            return builtin.live_grep({ cwd = client.config.root_dir })
                        end, { buffer = args.buf })
                    end
                    map("n", "<leader>h", vim.lsp.buf.hover, "textDocument/hover")
                    map("n", "<leader>r", vim.lsp.buf.rename, "textDocument/rename")
                    map("n", "gd", builtin.lsp_definitions, "textDocument/definition")
                    map("n", "gD", vim.lsp.buf.declaration, "textDocument/declaration")
                    map("n", "gr", builtin.lsp_references, "textDocument/references")
                    map("n", "gt", builtin.lsp_type_definitions, "textDocument/typeDefinition*")
                    map("n", "gI", builtin.lsp_implementations, "textDocument/implementation")
                    map("n", "<leader>ds", builtin.lsp_document_symbols, "textDocument/documentSymbol")
                    map("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, "workspace/symbol")
                    map("n", "<leader>f", function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id or nil }) end,
                        "textDocument/formatting")
                end,
            })
            local servers = {
                clangd = {},
                ocamllsp = {},
                pylsp = {},
                bashls = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            diagnostics = { disable = { "missing-fields" } },
                        },
                    }
                }
            }
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        if servers[server_name] ~= nil then
                            local server = servers[server_name]
                            require("lspconfig")[server_name].setup(server)
                        end
                    end,
                }
            })
        end
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
        lazy = false,   -- This plugin is already lazy
    },
    {
        "gbprod/cutlass.nvim",
        opts = {
            cut_key = "m",
            override_del = true,
        },
        lazy = false,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "stevearc/oil.nvim",
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, bufnr)
                        local m = name:match("%.%.")
                        return m ~= nil
                    end,
                }
            })
        end,
        lazy = false,
    },
    { "akinsho/git-conflict.nvim", tag = "v2.1.0", config = true },
    { "sangdol/mintabline.vim" },
    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },

        version = "1.*",
        opts = {
            keymap = { preset = "default" },

            appearance = {
                nerd_font_variant = "mono"
            },
            completion = { documentation = { auto_show = true } },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    }
})
