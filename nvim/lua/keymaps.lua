vim.g.mapleader = " "
vim.opt.signcolumn = "no"

-- Tabs
vim.keymap.set({'n','v'}, "<leader>1", function() vim.cmd("tabn1") end)
vim.keymap.set({'n','v'}, "<leader>2", function() vim.cmd("tabn2") end)
vim.keymap.set({'n','v'}, "<leader>3", function() vim.cmd("tabn3") end)
vim.keymap.set({'n','v'}, "<leader>4", function() vim.cmd("tabn4") end)
vim.keymap.set({'n','v'}, "<leader>5", function() vim.cmd("tabn5") end)
vim.keymap.set({'n','v'}, "<leader>6", function() vim.cmd("tabn6") end)
vim.keymap.set({'n','v'}, "<leader>7", function() vim.cmd("tabn7") end)
vim.keymap.set({'n','v'}, "<leader>8", function() vim.cmd("tabn8") end)
vim.keymap.set({'n','v'}, "<leader>9", function() vim.cmd("tabn9") end)
vim.keymap.set({'n','v'}, "<leader>0", function() vim.cmd("tabn10") end)
vim.keymap.set({'n','v'}, "<leader>n", function() vim.cmd("$tabnew") end)

