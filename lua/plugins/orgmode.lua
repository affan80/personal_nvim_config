return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    dependencies = {
      "nvim-orgmode/org-bullets.nvim",
      "nvim-orgmode/telescope-orgmode.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local org_dir = vim.fn.expand("~/orgfiles")
      local default_notes = org_dir .. "/refile.org"

      require("orgmode").setup({
        org_agenda_files = { org_dir .. "/**/*" },
        org_default_notes_file = default_notes,
        org_startup_folded = "content",
        org_startup_indented = true,
        org_hide_emphasis_markers = true,
        org_log_done = "time",
        org_log_into_drawer = "LOGBOOK",
        win_split_mode = "float",
        win_border = "rounded",
        org_todo_keywords = {
          "TODO(t)",
          "NEXT(n)",
          "WAITING(w)",
          "|",
          "DONE(d)",
          "CANCELLED(c)",
        },
        org_todo_keyword_faces = {
          NEXT = ":foreground #83a598 :weight bold",
          WAITING = ":foreground #fabd2f :weight bold",
          CANCELLED = ":foreground #928374 :slant italic",
        },
        org_capture_templates = {
          t = {
            description = "Task",
            template = "* TODO %?\n  %u",
            target = default_notes,
          },
          n = {
            description = "Note",
            template = "* %?\n  %u",
            target = default_notes,
          },
          j = {
            description = "Journal",
            template = "\n* %<%Y-%m-%d %A>\n** %U\n\n%?",
            target = org_dir .. "/journal.org",
          },
        },
      })

      pcall(vim.lsp.enable, "org")

      local ok_bullets, bullets = pcall(require, "org-bullets")
      if ok_bullets then
        bullets.setup()
      end

      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
        cmp.setup.filetype("org", {
          sources = cmp.config.sources({
            { name = "orgmode" },
            { name = "nvim_lsp" },
            { name = "luasnip" },
          }, {
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "org",
        callback = function()
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nc"
        end,
      })

      local ok_telescope, telescope = pcall(require, "telescope")
      if ok_telescope then
        pcall(telescope.load_extension, "orgmode")
        local ext = telescope.extensions.orgmode

        if ext then
          vim.keymap.set("n", "<leader>oh", ext.search_headings, { desc = "Org Headings" })
          vim.keymap.set("n", "<leader>oT", ext.search_tags, { desc = "Org Tags" })
          vim.keymap.set("n", "<leader>oR", ext.refile_heading, { desc = "Org Refile With Telescope" })
          vim.keymap.set("n", "<leader>ol", ext.insert_link, { desc = "Org Insert Link" })
        end
      end
    end,
  },
}
