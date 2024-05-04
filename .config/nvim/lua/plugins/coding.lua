return {
  {
    "hrsh7th/nvim-cmp",
    depends = {
      "catppuccin/nvim",
    },
    config = {
      window = {
        completion = {
          -- custom border
          border = {
            "󱐋",
            "─",
            "╮",
            "│",
            "╯",
            "─",
            "╰",
            "│",
          },
          scrollbar = false,
        },
        documentation = {
          border = {
            "",
            "─",
            "╮",
            "│",
            "╯",
            "─",
            "╰",
            "│",
          },
          scrollbar = false,
        },
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      local home = vim.fn.expand("$HOME")
      require("chatgpt").setup({
        api_key_cmd = "gpg --decrypt " .. home .. "/.config/nvim/secrets/chatgpt_api_key.txt.gpg",
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "vuki656/package-info.nvim",
    depends = "MunifTanjim/nui.nvim",
    config = function()
      local colors = require("catppuccin.palettes").get_palette("mocha")
      require("package-info").setup({
        package_manager = "npm",
        colors = {
          outdated = colors.peach,
        },
        hide_up_to_date = true,
      })
    end,
  },
}
