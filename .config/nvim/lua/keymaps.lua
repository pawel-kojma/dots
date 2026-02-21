vim.g.mapleader = " "

-- Oil
vim.keymap.set("n", "<leader>x", "<CMD>Oil<CR>", { desc = "E[x]plore current directory" })

-- Tabs
vim.keymap.set({ "n", "v" }, ";", function()
	local vcnt = vim.v.count1
	if vim.fn.tabpagenr("$") >= vcnt then
		vim.cmd("tabn" .. vcnt)
	end
end)
vim.keymap.set({ "n", "v" }, "tc", function()
	vim.cmd("tabclose")
end)
vim.keymap.set({ "n", "v" }, "th", function()
	vim.cmd("-tabmove")
end)
vim.keymap.set({ "n", "v" }, "tl", function()
	vim.cmd("+tabmove")
end)
vim.keymap.set({ "n", "v" }, "tn", function()
	local oil = require("oil")
	local path = vim.fn.expand("%:h")
	vim.cmd("tabnew")
	oil.open(path)
end)

-- Diagnostics
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
vim.keymap.set({ "n", "v" }, "<leader>dt", toggle_diagnostics)
