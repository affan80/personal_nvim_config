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

  -- LazyGit UI inside Neovim
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      vim.g.lazygit_use_neovim_in_terminals = true
      vim.g.lazygit_use_custom_config_file_path = false
    end,
  },
}
