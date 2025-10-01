vim.g.mapleader = " "

-- Oil
vim.keymap.set("n", "<leader>x", "<CMD>Oil<CR>", { desc = "E[x]plore current directory" })

-- Tabs
local tab_map = function(idx)
    local sid = tostring(idx)
    if idx == 10 then
        vim.keymap.set({ 'n', 'v' }, "<leader>0", function()
            if vim.fn.tabpagenr('$') >= idx then
                vim.cmd("tabn10")
            end
        end)
    else
        vim.keymap.set({ 'n', 'v' }, "<leader>" .. sid, function()
            if vim.fn.tabpagenr('$') >= idx then
                vim.cmd("tabn" .. sid)
            end
        end)
    end
end

for i = 1, 10 do
    tab_map(i)
end
vim.keymap.set({ 'n', 'v' }, "<leader>tc", function() vim.cmd("tabclose") end)
vim.keymap.set({ 'n', 'v' }, "<leader>th", function() vim.cmd("-tabmove") end)
vim.keymap.set({ 'n', 'v' }, "<leader>tl", function() vim.cmd("+tabmove") end)
vim.keymap.set({ 'n', 'v' }, "<leader>tn", function()
    local oil = require('oil')
    local path = vim.fn.expand("%:h")
    vim.cmd("tabnew")
    oil.open(path)
end)

local is_diagnostics_on = false
local function toggle_diagnostics()
    local opts = { -- https://neovim.io/doc/user/diagnostic.html
        virtual_text = false,
        signs = false,
        underline = false,
    }
    if is_diagnostics_on then
        opts.virtual_text = true
        opts.underline = true
    else
        opts.virtual_text = false
        opts.underline = false
    end
    is_diagnostics_on = not is_diagnostics_on
    vim.diagnostic.config(opts)
end

-- Diagnostics off by default
toggle_diagnostics()
vim.keymap.set({ 'n', 'v' }, "<leader>dt", toggle_diagnostics)
