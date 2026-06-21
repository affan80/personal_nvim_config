return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "hydrogen",
      output_extension = "auto",
      force_ft = nil,
    },
  },

  {
    "benlubas/molten-nvim",

    -- FORCE LOAD
    lazy = false,

    -- Make sure remote plugin is built
    build = ":UpdateRemotePlugins",

    dependencies = {
      "3rd/image.nvim",
    },

    config = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_wrap_output = true
      vim.g.molten_auto_open_output = true
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_tick_rate = 200
      vim.g.molten_save_path = vim.fn.stdpath("data") .. "/molten"
    end,
  },
}
