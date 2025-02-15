vim.g.mapleader = " "
vim.opt.signcolumn = "no"

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

for i=1,10 do
    tab_map(i)
end
vim.keymap.set({ 'n', 'v' }, "<leader>tc", function() vim.cmd("tabclose") end)
vim.keymap.set({ 'n', 'v' }, "<leader>th", function() vim.cmd("-tabmove") end)
vim.keymap.set({ 'n', 'v' }, "<leader>tl", function() vim.cmd("+tabmove") end)
vim.keymap.set({ 'n', 'v' }, "<leader>tn", function()
    local path = vim.fn.expand("%:h")
    vim.cmd("tabnew");
    vim.cmd("Oil " .. path);
end)
