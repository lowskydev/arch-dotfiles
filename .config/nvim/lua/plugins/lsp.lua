return {
  -- Mason v2: installs and manages LSP servers
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Bridges mason and lspconfig (v2)
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",        -- C/C++
          "pyright",       -- Python
          "rust_analyzer", -- Rust
          "jdtls",         -- Java
          "ts_ls",         -- TypeScript/JavaScript
          "lua_ls",        -- Lua
          "gopls",         -- Go
          "bashls",        -- Bash
          "jsonls",        -- JSON
          "taplo",         -- TOML
          "yamlls",        -- YAML
          "dockerls",      -- Dockerfile
          "html",          -- HTML
          "cssls",         -- CSS
        },
      })

      -- Shared keymaps applied when any LSP attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
        callback = function(args)
          local opts = { noremap = true, silent = true, buffer = args.buf }
          local keymap = vim.keymap.set
          keymap("n", "gd", vim.lsp.buf.definition, opts)
          keymap("n", "gD", vim.lsp.buf.declaration, opts)
          keymap("n", "gr", vim.lsp.buf.references, opts)
          keymap("n", "gi", vim.lsp.buf.implementation, opts)
          keymap("n", "K", vim.lsp.buf.hover, opts)
          keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
          keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          keymap("n", "<leader>d", vim.diagnostic.open_float, opts)
          keymap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
          keymap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
        end,
      })

      -- Capabilities enhanced with cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Apply capabilities to all servers
      local servers = {
        "clangd", "pyright", "rust_analyzer",
        "ts_ls", "gopls",
        "bashls", "jsonls", "taplo",
        "yamlls", "dockerls", "html", "cssls",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end

      -- Lua LSP special config (knows about nvim globals)
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
          },
        },
      })
    end,
  },
}
