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

      -- === FANCY CELL STYLING ===
      vim.g.molten_use_border_highlights = true
      vim.g.molten_output_win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      vim.g.molten_output_show_exec_time = true
      vim.g.molten_virt_text_max_lines = 15
      vim.g.molten_cover_empty_lines = false

      local group = vim.api.nvim_create_augroup("FancyCells", { clear = true })

      -- Cell highlight colors (green border = success, red = error)
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
          vim.api.nvim_set_hl(0, "MoltenOutputBorderSuccess", { fg = "#9ece6a" })
          vim.api.nvim_set_hl(0, "MoltenOutputBorderFail", { fg = "#f7768e" })
          vim.api.nvim_set_hl(0, "MoltenOutputBorder", { fg = "#7aa2f7" })
          vim.api.nvim_set_hl(0, "MoltenCell", { bg = "#1a1b26" })
          vim.api.nvim_set_hl(0, "MoltenVirtualText", { fg = "#565f89", italic = true })
          vim.api.nvim_set_hl(0, "MoltenOutputWin", { bg = "#16161e" })
          vim.api.nvim_set_hl(0, "MoltenOutputFooter", { fg = "#7dcfff", bold = true })
        end,
      })
      vim.cmd("doautocmd ColorScheme")

      -- Highlight #%% cell markers in hydrogen-style files + jump keys
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "python",
        callback = function(args)
          if vim.fn.search([[^# %%\|^#%%]], "nw") == 0 then return end
          vim.fn.matchadd("Title", [[^\s*#\+\s*%%.*$]])
          vim.fn.matchadd("Comment", [[^\s*#\+\s*%%\s*\[markdown\].*$]])
        end,
      })

      -- Jump between cells: ]c / [c
      vim.keymap.set("n", "]c", function()
        pcall(vim.cmd, [[silent! keepjumps normal! /^\s*#\+\s*%%\r]])
        vim.cmd("normal! zt")
      end, { desc = "Next cell" })
      vim.keymap.set("n", "[c", function()
        pcall(vim.cmd, [[silent! keepjumps normal! ?\^\s\*#\+\s\*%%?\r]])
        vim.cmd("normal! zt")
      end, { desc = "Previous cell" })

      -- Statusline indicator for running kernel (use in statusline: %g{molten_statusline})
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MoltenInitPost",
        callback = function()
          vim.g.molten_statusline = require("molten.status").kernels()
        end,
      })
    end,
  },
}
