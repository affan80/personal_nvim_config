return {
  "benlubas/molten-nvim",

  -- FORCE LOAD
  lazy = false,

  -- Make sure remote plugin is built
  build = ":UpdateRemotePlugins",

  dependencies = {
    "3rd/image.nvim",
  },

  config = function()
    vim.g.molten_image_provider = "kitty"
    vim.g.molten_wrap_output = true
    vim.g.molten_auto_open_output = true
    vim.g.molten_output_win_max_height = 20
  end,
}

