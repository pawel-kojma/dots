vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        -- Delete some default keybinds, set omnifunc
        vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        vim.keymap.del('n', 'K', { buffer = args.buf })

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.supports_method('textDocument/hover') then
            vim.keymap.set({'n', 'v'}, "<leader>h", function() vim.lsp.buf.hover() end)
        end
        if client.supports_method('textDocument/definition') then
            vim.keymap.set({'n', 'v'}, "gd", function() vim.lsp.buf.definition() end)
        end
        if client.supports_method('textDocument/rename') then
            vim.keymap.set({'n', 'v'}, "<leader>r", function() vim.lsp.buf.rename() end)
        end
    end,
})
