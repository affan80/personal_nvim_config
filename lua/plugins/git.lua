return {
  -- Git signs in the gutter and hunk management
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "+" },
          change       = { text = "~" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true,
      })
    end,
  },

  -- The best Git wrapper for Vim
  {
    "tpope/vim-fugitive",
  },

  -- GitHub extension for Fugitive (enables :GBrowse)
  {
    "tpope/vim-rhubarb",
  },
}
