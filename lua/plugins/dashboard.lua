return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
  "",
  "██╗  ██╗███████╗██████╗ ███╗   ██╗ █████╗ ██╗     ",
  "██║ ██╔╝██╔════╝██╔══██╗████╗  ██║██╔══██╗██║     ",
  "█████╔╝ █████╗  ██████╔╝██╔██╗ ██║███████║██║     ",
  "██╔═██╗ ██╔══╝  ██╔══██╗██║╚██╗██║██╔══██║██║     ",
  "██║  ██╗███████╗██║  ██║██║ ╚████║██║  ██║███████╗",
  "╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝",
  "",
  " ██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗",
  "██╔════╝ ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝",
  "██║  ███╗███████║██║   ██║███████╗   ██║   ",
  "██║   ██║██╔══██║██║   ██║╚════██║   ██║   ",
  "╚██████╔╝██║  ██║╚██████╔╝███████║   ██║   ",
  " ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ",
  "",
}


      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
        dashboard.button("n", "  New File", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recent Files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "  Find Text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      dashboard.section.footer.val = { " ", " Happy Coding with Kernel Ghost" }

      alpha.setup(dashboard.opts)
    end,
  },
}
