return {
  {
    "ggandor/leap.nvim",
    config = function() require("leap").add_default_mappings() end,
  },
  {
    "ggandor/flit.nvim",
    lazy = true,
    event = "BufReadPost",
    dependencies = { "ggandor/leap.nvim" },
    config = function()
      require("flit").setup {
        keys = { f = "f", F = "F", t = "t", T = "T" },
        labeled_modes = "v",
        multiline = true,
        opts = {},
      }
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require("neoscroll").setup {
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
      }
    end,
  },
  {
    "LunarVim/lunar.nvim",
  },
  {
    "nat-418/boole.nvim",
    lazy = false,
    config = function()
      require("boole").setup {
        mappings = {
          increment = "<M-i>",
          decrement = "<M-o>",
        },
        -- User defined loops
        additions = {},
        allow_caps_additions = {
          { "enable", "disable" },
          {
            "CRITICAL",
            "ERROR",
            "ARNING",
            "DEBUG",
            "INFO",
          },
          -- enable → disable
          -- Enable → Disable
          -- ENABLE → DISABLE
        },
      }
    end,
  },
  {
    "JuanZoran/Trans.nvim",
    build = function() require("Trans").install() end,
    keys = {
      -- 可以换成其他你想映射的键
      { "mm", mode = { "n", "x" }, "<Cmd>Translate<CR>", desc = " Translate" },
      { "mk", mode = { "n", "x" }, "<Cmd>TransPlay<CR>", desc = " Auto Play" },
      -- 目前这个功能的视窗还没有做好，可以在配置里将view.i改成hover
      { "mi", "<Cmd>TranslateInput<CR>", desc = " Translate From Input" },
    },
    dependencies = { "kkharji/sqlite.lua" },
    opts = {
      -- your configuration there
    },
  },
  "Nguyen-Hoang-Nam/nvim-mini-file-icons",

  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  -- { "kaarmu/typst.vim", ft = "typst", lazy = false },
  { "git@github.com:terryma/vim-multiple-cursors.git", lazy = false },
  {
    "chomosuke/typst-preview.nvim",
    -- lazy = false, -- or ft = 'typst'
    ft = "typst",
    version = "0.1.*",
    build = function() require("typst-preview").update() end,
  },
  -- "niuiic/typst-preview.nvim",
}
