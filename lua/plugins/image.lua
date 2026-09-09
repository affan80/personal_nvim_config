return {
  "3rd/image.nvim",
  lazy = false,
  build = false,
  opts = {
    backend = "kitty", -- kitty graphics protocol (works in kitty/wezterm/ghostty)
    kitty_method = "normal",
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = 80,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true, -- hide images when a popup floats over them
    tmux_show_only_in_active_window = false,
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" },
      },
      neorg = { enabled = false },
      orgmode = { enabled = true, filetypes = { "org" } },
      html = { enabled = false },
      css = { enabled = false },
    },
  },
}
