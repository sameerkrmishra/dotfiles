-- Map the leader keys at the top so that all other keybindings see it.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")

-- Basic editor setup
vim.opt.path:append("**")

tabwidth = 2
vim.opt.tabstop = tabwidth
vim.opt.softtabstop = tabwidth
vim.opt.shiftwidth = tabwidth

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keybindings
vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<CR>", { desc = "Sources config changes" })
vim.keymap.set("n", "<leader>l", ":nohl<CR>", {desc = "Clear highlights from the last search"})

-- Custom functions
-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

