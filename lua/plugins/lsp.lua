return {
  -- Mason for managing external tooling
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      local ok, mason = pcall(require, "mason")
      if ok then mason.setup() end
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
      if not ok_mason then return end

      -- Capabilities for nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp_lsp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      local servers = {
        "ts_ls", "eslint", "tailwindcss", "html", "cssls", "jsonls",
        "lua_ls", "pyright", "rust_analyzer", "gopls", "clangd",
        "jdtls", "intelephense", "ruby_lsp", "bashls",
        "yamlls", "dockerls", "marksman", "terraformls"
      }

      -- MATLAB language server (only when MATLAB is installed)
      if vim.fn.executable("matlab") == 1 then
        table.insert(servers, "matlab_ls")
      end

      -- Mason-LSPConfig v2: install servers only; enabling is manual
      mason_lspconfig.setup({ ensure_installed = servers })

      -- Default config applied to every enabled server
      vim.lsp.config("*", { capabilities = capabilities })

      -- Server-specific settings
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
          },
        },
      })

      -- Enable all servers (native 0.11+ API)
      for _, server in ipairs(servers) do
        pcall(vim.lsp.enable, server)
      end
    end,
  },

  -- Global LSP Keymaps (on attach)
  -- (kept as a separate lazy spec so it always registers early)
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
          vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    config = function()
      local ok_cmp, cmp = pcall(require, "cmp")
      local ok_snip, luasnip = pcall(require, "luasnip")
      local ok_kind, lspkind = pcall(require, "lspkind")
      
      if not (ok_cmp and ok_snip) then return end

      pcall(function()
        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          formatting = {
            format = ok_kind and lspkind.cmp_format({
              mode = "symbol_text",
              maxwidth = 50,
              ellipsis_char = "...",
            }) or nil,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
          }, {
            { name = "buffer" },
            { name = "path" },
          }),
        })

        -- Use buffer source for `/` and `?`
        cmp.setup.cmdline({ "/", "?" }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer" }
          }
        })

        -- Use cmdline & path source for ':'
        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path" }
          }, {
            { name = "cmdline" }
          })
        })
      end)
    end,
  },
}
