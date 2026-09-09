return {
  -- Smooth cursor / scroll / window animations
  {
    "echasnovski/mini.animate",
    version = "*",
    event = "VeryLazy",
    config = function()
      local animate = require("mini.animate")
      local timing = animate.gen_timing.linear({ duration = 80, unit = "total" })
      animate.setup({
        cursor = { timing = timing },
        scroll = { timing = timing },
        resize = { timing = timing },
        open = { enable = false }, -- avoid conflict with float terminals/dap-ui
        close = { enable = false },
      })
    end,
  },

  -- Animated indent guides (subtle motion when jumping between scopes)
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mini.indentscope").setup({
        symbol = "▏",
        options = { try_as_border = true },
        draw = { animation = require("mini.indentscope").gen_animation.none() },
      })
    end,
  },
}
