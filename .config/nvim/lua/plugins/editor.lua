return {
  {
    "echasnovski/mini.bufremove",

    keys = {
      { "<leader>bd", false },
      { "<leader>bD", false },
      {
        "<leader>bk",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      -- stylua: ignore
      { "<leader>bK", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      -- plugins = { spelling = true },
      defaults = {
        ["<leader>f"] = { name = "+file/find/focus" },
        ["<leader>m"] = { name = "+move" },
        ["<leader>r"] = { name = "+resice" },
        ["<leader>h"] = { name = "+help" },
        ["<leader>p"] = { name = "+project" },
        ["<leader>cp"] = { name = "+package" },
        ["<leader>a"] = { name = "+ai" },
        ["<leader>t"] = { name = "+test/theme" },
      },
    },
  },
  {
    "sindrets/winshift.nvim",
    opts = {
      highlight_moving_win = true, -- Highlight the window being moved
      focused_hl_group = "Visual", -- The highlight group used for the moving window
      moving_win_options = {
        -- These are local options applied to the moving window while it's
        -- being moved. They are unset when you leave Win-Move mode.
        wrap = false,
        cursorline = false,
        cursorcolumn = false,
        colorcolumn = "",
      },
      keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        win_move_mode = {
          ["h"] = "left",
          ["j"] = "down",
          ["k"] = "up",
          ["l"] = "right",
          ["H"] = "far_left",
          ["J"] = "far_down",
          ["K"] = "far_up",
          ["L"] = "far_right",
          ["<left>"] = "left",
          ["<down>"] = "down",
          ["<up>"] = "up",
          ["<right>"] = "right",
          ["<S-left>"] = "far_left",
          ["<S-down>"] = "far_down",
          ["<S-up>"] = "far_up",
          ["<S-right>"] = "far_right",
        },
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
      "andrew-george/telescope-themes",
    },
    keys = {
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },
      {
        "<leader>.",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            no_ignore = false,
            hidden = true,
          })
        end,
        desc = "Find files (cwd no hidden)",
      },
      {
        "<leader>fF",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            no_ignore = false,
            hidden = true,
            cwd = "$HOME",
          })
        end,
        desc = "Find files (root no hidden)",
      },
      {
        "<leader>fg",
        function()
          local builtin = require("telescope.builtin")
          builtin.live_grep()
        end,
        desc = "Grep files in cwd",
      },
      {
        "<leader>bi",
        function()
          local builtin = require("telescope.builtin")
          builtin.buffers()
        end,
        desc = "Lists open buffers",
      },
      {
        "<leader>hh",
        function()
          local builtin = require("telescope.builtin")
          builtin.help_tags()
        end,
        desc = "Find help tags",
      },
      {
        ";;", -- no clue what this is doing
        function()
          local builtin = require("telescope.builtin")
          builtin.resume()
        end,
        desc = "Resume the previous telescope picker",
      },
      {
        ";e", --not working
        function()
          local builtin = require("telescope.builtin")
          builtin.diagnostics()
        end,
        desc = "Lists Diagnostics for all open buffers or a specific buffer",
      },
      {
        ";s",
        function()
          local builtin = require("telescope.builtin")
          builtin.treesitter()
        end,
        desc = "Lists Function names, variables, from Treesitter",
      },
      {
        "<leader>ff",
        function()
          local telescope = require("telescope")

          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end

          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
        desc = "Open File Browser",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          n = {},
        },
      })
      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      }
      opts.extensions = {
        themes = {
          -- you can add regular telescope config
          -- that you want to apply on this picker only
          layout_config = {
            horizontal = {
              width = 0.8,
              height = 0.7,
            },
          },
          -- extension specific config
          enable_previewer = true, -- (boolean) -> show/hide previewer window
          enable_live_preview = true, -- (boolean) -> enable/disable live preview
          ignore = {
            "default",
            "desert",
            "elflord",
            "blue",
            "peachpuff",
            "shine",
            "darkblue",
            "delek",
            "catppuccin-latte",
            "morning",
            "zellner",
            "tokyonight-day",
            "kanagawa-lotus",
            "onenord-light",
            "solarized-osaka-day",
          },
          -- (table) -> provide table of theme names to ignore
          -- all builtin themes are ignored by default
        },
        file_browser = {
          theme = "dropdown",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            -- your custom insert mode mappings
            ["n"] = {
              -- your custom normal mode mappings
              ["n"] = fb_actions.create,
              ["r"] = fb_actions.rename,
              ["d"] = fb_actions.remove,
              ["m"] = fb_actions.move,
              ["H"] = fb_actions.goto_home_dir,
              ["c"] = fb_actions.goto_cwd,
              ["C"] = fb_actions.change_cwd,
              ["h"] = fb_actions.goto_parent_dir,
              ["<left>"] = fb_actions.goto_parent_dir,
              ["/"] = function()
                vim.cmd("startinsert")
              end,
              ["U"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["D"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
              ["<PageUp>"] = actions.preview_scrolling_up,
              ["-<PageDown>"] = actions.preview_scrolling_down,
            },
          },
        },
      }
      telescope.setup(opts)
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end,
  },
  {
    "stevearc/aerial.nvim",
    event = "LazyFile",
    opts = {
      close_automatic_events = { "unfocus" },
      manage_folds = true,
      link_folds_to_tree = true,
      link_tree_to_folds = true,
    },
  },
  -- {
  --   "ojroques/vim-oscyank",
  --   config = function()
  --     -- Should be accompanied by a setting clipboard in tmux.conf, also see
  --     -- https://github.com/ojroques/vim-oscyank#the-plugin-does-not-work-with-tmux
  --     vim.g.oscyank_term = "default"
  --     vim.g.oscyank_max_length = 0 -- unlimited
  --     -- Below autocmd is for copying to OSC52 for any yank operation,
  --     -- see https://github.com/ojroques/vim-oscyank#copying-from-a-register
  --     vim.api.nvim_create_autocmd("TextYankPost", {
  --       pattern = "*",
  --       callback = function()
  --         if vim.v.event.operator == "y" and vim.v.event.regname == "" then
  --           vim.cmd('OSCYankRegister "')
  --         end
  --       end,
  --     })
  --   end,
  -- },
  {
    "f-person/git-blame.nvim",
    opts = {
      enabled = false,
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    lazy = false,
  },
  {
    "NvChad/nvim-colorizer.lua",
    lazy = false,
    config = function()
      require("colorizer").setup()
    end,
  },
}
