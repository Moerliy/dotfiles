-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

-- Diagnostics
keymap.set("n", "<Leader>xn", function()
  vim.diagnostic.goto_next()
end, { desc = "Next Vim diagnostic" })

-- Window management
keymap.set("n", "<Leader>wk", ":close", { desc = "Delete window" })
keymap.set("n", "<Leader>ws", ":split<Return>", { noremap = true, silent = true, desc = "Horizontal split window" })
keymap.set("n", "<Leader>wv", ":vsplit<Return>", { noremap = true, silent = true, desc = "Vertical split window" })
keymap.set("n", "<Leader>f<left>", "<C-w>h", { desc = "Focus window left" })
keymap.set("n", "<Leader>f<up>", "<C-w>k", { desc = "Focus window up" })
keymap.set("n", "<Leader>f<down>", "<C-w>j", { desc = "Focus window down" })
keymap.set("n", "<Leader>f<right>", "<C-w>l", { desc = "Focus window right" })
keymap.set("n", "<Leader>mm", ":WinShift<Return>", { desc = "Move mode" })
keymap.set("n", "<Leader>r<left>", "<C-w><")
keymap.set("n", "<Leader>r<right>", "<C-w>>")
keymap.set("n", "<Leader>r<up>", "<C-w>+")
keymap.set("n", "<Leader>r<down>", "<C-w>-")

-- Notificon
keymap.set("n", "<Leader>uN", ":Telescope notify<Return>", { desc = "Show all notifications" })

-- Toggleterm
keymap.set("n", "<Leader>T", ":ToggleTerm<Return>", { desc = "Toggle terminal" })

-- dotfiles lazygit with toggleterm
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit --git-dir=$HOME/dotfiles --work-tree=$HOME", hidden = true })
function _lazygit_toggle()
  lazygit:toggle()
end
keymap.set("n", "<leader>fC", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
