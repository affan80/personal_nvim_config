return {
  {
    "echasnovski/mini.animate",
    version = "*",
    event = "VeryLazy",
    config = function()
      local animate = require("mini.animate")
      animate.setup({
        cursor = { timing = animate.gen_timing.linear({ duration = 120, unit = "total" }) },
        scroll = { timing = animate.gen_timing.linear({ duration = 120, unit = "total" }) },
        resize = { timing = animate.gen_timing.linear({ duration = 100, unit = "total" }) },
        open = { enabled = true },
        close = { enabled = true },
      })
    end,
  },
}
