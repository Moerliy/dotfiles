-------------------------------------------------
-- DT'S NEOVIM CONFIGURATION
-- Neovim website: https://neovim.io/
-- DT's dotfiles: https://gitlab.com/dwt1/dotfiles
-------------------------------------------------

local status, orgmode = pcall(require, "orgmode")
if not status then
	return
end

orgmode.setup({
	org_agenda_files = { "~/nc/Org/agenda.org" },
	org_default_notes_file = "~/nc/Org/notes.org",
})

orgmode.setup_ts_grammar()
