return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    },
    config = function()
      local wk = require("which-key")
      wk.setup()
      
      -- Register group names for a better UI
      wk.add({
        { "<leader>g", group = "Git / GitHub" },
        { "<leader>d", group = "Debugger (DAP)" },
        { "<leader>w", group = "Windows / Save" },
        { "<leader>f", group = "Find (Telescope) / Format" },
        { "<leader>t", group = "Terminal" },
        { "<leader>m", group = "Molten (Jupyter)" },
        { "<leader>r", group = "Run / Rollback" },
        { "<leader>o", group = "Orgmode" },
      })
    end
  }
}
