return {

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = false,    
            hide_gitignored = false,
          },
        },
        window = {
          position = "left",
          width = 30,
          mappings = {
            ["<space>"] = "toggle_node",
            ["h"] = "close_node",
            ["l"] = "open",
          },
        },
      })
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = 'float',
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git", "venv" },
        },
      })
    end,
  },

  -- Treesitter for better syntax highlighting (main-branch API)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter")
      if not ok then return end

      local parsers = {
        "lua", "vim", "vimdoc", "javascript", "typescript", "tsx", "html", "css",
        "json", "python", "rust", "go", "cpp", "c", "java", "php", "ruby", "bash",
        "yaml", "dockerfile", "markdown", "markdown_inline"
      }
      pcall(ts.install, parsers)

      local ft_map = {
        lua = "lua", vim = "vim", vimdoc = "vimdoc", javascript = "javascript",
        typescript = "typescript", typescriptreact = "tsx", javascriptreact = "tsx",
        html = "html", css = "css", json = "json", python = "python", rust = "rust",
        go = "go", cpp = "cpp", c = "c", java = "java", php = "php", ruby = "ruby",
        sh = "bash", yaml = "yaml", dockerfile = "dockerfile", markdown = "markdown",
      }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.tbl_keys(ft_map),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },

  -- Bufferline (Tabs)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({})
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Auto tag (HTML/JSX)
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  }
}


