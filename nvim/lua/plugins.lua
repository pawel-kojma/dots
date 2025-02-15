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
                ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "ocaml",
                            "javascript", "markdown", "menhir", "python", "typescript", "sql", "jinja"},
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
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch with [G]rep" })
            vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers" })
            vim.keymap.set("n", "<leader>st", builtin.filetypes, { desc = "[S]earch File[t]ypes" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>/", function ()
                builtin.current_buffer_fuzzy_find(
                require("telescope.themes")
                .get_dropdown({previewer = false, winblend = 10,}))
            end, { desc = "Search current buffer" })
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {"mason.nvim"},
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "nvim-telescope/telescope.nvim"
        },
        config = function ()
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    -- Delete some default keybinds, set omnifunc
                    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
                    vim.keymap.del('n', 'K', { buffer = args.buf })
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local map = function (mode, bind, func, cond)
                        if client ~= nil and client.supports_method(cond) then
                            vim.keymap.set(mode, bind, func)
                        end
                    end
                    map({'n', 'v'}, "<leader>h", vim.lsp.buf.hover, 'textDocument/hover')
                    map({'n', 'v'}, "gd", vim.lsp.buf.definition, 'textDocument/definition')
                    map({'n', 'v'}, "<leader>r", vim.lsp.buf.rename, 'textDocument/rename')
                end,
            })
            local servers = {
                clangd = {},
                pyright = {},
                ocamllsp = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            diagnostics = { disable = { 'missing-fields' } },
                        },
                    }
                }
            }
            require("mason-lspconfig").setup({
                handlers = {
                    function (server_name)
                        local server = servers[server_name] or {}
                        require("lspconfig")[server_name].setup(server)
                    end,
                }
            })
        end
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
})

