return {
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
      show_hidden = true,
      silent_chdir = false,
    },
    keys = {
      { "<leader>fp", false },
      { "<leader>pp", "<Cmd>Telescope projects<CR>", desc = "Open projects" },
    },
  },
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      local ft = require("Comment.ft")
      ft.set("kt", "// %s")
    end,
    opts = {},
  },
  {
    "tris203/precognition.nvim",
    config = {
      startVisible = false,
    },
  },
}
