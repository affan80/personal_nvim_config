return {
  -- Mason for managing external tooling
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      local ok, mason = pcall(require, "mason")
      if ok then mason.setup() end
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { 
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local ok_lsp, lspconfig = pcall(require, "lspconfig")
      local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
      local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      
      if not (ok_lsp and ok_mason) then return end

      -- Capabilities for nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if ok_cmp_lsp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- 1. Setup Mason-LSPConfig
      if mason_lspconfig.setup then
        mason_lspconfig.setup({
          ensure_installed = {
            "ts_ls", "eslint", "tailwindcss", "html", "cssls", "jsonls",
            "lua_ls", "pyright", "rust_analyzer", "gopls", "clangd", 
            "jdtls", "intelephense", "ruby_lsp", "bashls",
            "yamlls", "dockerls", "marksman", "terraformls"
          },
        })
      end

      -- 2. Global LSP Keymaps (on attach)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })

      -- 3. Setup Handlers (with existence check)
      if mason_lspconfig.setup_handlers then
        mason_lspconfig.setup_handlers({
          function(server_name)
            pcall(function() 
              lspconfig[server_name].setup({
                capabilities = capabilities,
              }) 
            end)
          end,
          ["lua_ls"] = function()
            pcall(function()
              lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                  Lua = {
                    diagnostics = { globals = { "vim" } },
                  },
                },
              })
            end)
          end,
          ["rust_analyzer"] = function()
            pcall(function()
              lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                settings = {
                  ["rust-analyzer"] = {
                    cargo = { allFeatures = true },
                    checkOnSave = { command = "clippy" },
                  },
                },
              })
            end)
          end,
        })
      end
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
