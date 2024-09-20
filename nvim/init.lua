-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Searching
vim.opt.hlsearch = false

-- Tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4

-- Line wrap
vim.opt.wrap = false

-- Scroll
vim.opt.scrolloff = 999

-- Cliboard
vim.opt.clipboard = "unnamedplus"

-- Splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Colors
vim.opt.termguicolors = true

-- Edit
vim.opt.virtualedit = "block"

-- Preview & Commands
vim.opt.inccommand = "split"
vim.opt.ignorecase = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "EdenEast/nightfox.nvim"
})

vim.cmd.colorscheme("carbonfox")

