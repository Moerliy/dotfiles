-------------------------------------------------
-- DT'S NEOVIM CONFIGURATION
-- Neovim website: https://neovim.io/
-- DT's dotfiles: https://gitlab.com/dwt1/dotfiles
-------------------------------------------------

-------------------------------------------------
-- KEYBINDINGS
-------------------------------------------------

local function map(m, k, v)
	vim.keymap.set(m, k, v, { silent = true })
end

-- Mimic shell movements
map("i", "<C-E>", "<ESC>A")
map("i", "<C-A>", "<ESC>I")

-- Load recent sessions
map("n", "<leader>sl", "<CMD>SessionLoad<CR>")

-- Keybindings for telescope
map("n", "<leader>fr", "<CMD>Telescope oldfiles<CR>")
map("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
map("n", "<leader>fb", "<CMD>Telescope file_browser<CR>")
map("n", "<leader>fw", "<CMD>Telescope live_grep<CR>")
map("n", "<leader>ht", "<CMD>Telescope colorscheme<CR>")
