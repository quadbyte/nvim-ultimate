-- ══════════════════════════════════════════════════════════════════════
-- LSP Configuration
-- Language Server Protocol setup with profile-based loading
-- ══════════════════════════════════════════════════════════════════════

return {
  -- LSPConfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      inlay_hints = {
        enabled = false,
      },
      capabilities = {},
    },
    config = function(_, opts)
      -- Setup diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
          map("<leader>lr", vim.lsp.buf.rename, "[R]ename")
          map("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- Highlight references under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Setup LSP servers based on profile
      local profile = require("utils.profile")
      local lsp_servers = profile.get_lsp_servers()
      local mason_lspconfig = require("mason-lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local function setup(server)
        local server_opts = {
          capabilities = vim.deepcopy(capabilities),
        }
        require("lspconfig")[server].setup(server_opts)
      end

      -- Ensure LSP servers are installed
      mason_lspconfig.setup({
        ensure_installed = lsp_servers,
        handlers = { setup },
      })
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason LSPConfig bridge
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format({ timeout_ms = 500, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = function()
      local profile = require("utils.profile")
      local formatters = profile.get_formatters()

      -- Build formatters_by_ft from profile
      local formatters_by_ft = {}
      if vim.tbl_contains(formatters, "prettier") then
        formatters_by_ft.javascript = { "prettier" }
        formatters_by_ft.typescript = { "prettier" }
        formatters_by_ft.javascriptreact = { "prettier" }
        formatters_by_ft.typescriptreact = { "prettier" }
        formatters_by_ft.json = { "prettier" }
        formatters_by_ft.html = { "prettier" }
        formatters_by_ft.css = { "prettier" }
        formatters_by_ft.markdown = { "prettier" }
      end
      if vim.tbl_contains(formatters, "black") then
        formatters_by_ft.python = { "black" }
      end
      if vim.tbl_contains(formatters, "gofmt") then
        formatters_by_ft.go = { "gofmt" }
      end
      if vim.tbl_contains(formatters, "rustfmt") then
        formatters_by_ft.rust = { "rustfmt" }
      end

      return {
        formatters_by_ft = formatters_by_ft,
        format_on_save = function()
          if vim.g.disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_fallback = true }
        end,
      }
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = function(_, item)
            local icons = {
              Array = " ",
              Boolean = " ",
              Class = " ",
              Color = " ",
              Constant = " ",
              Constructor = " ",
              Enum = " ",
              EnumMember = " ",
              Event = " ",
              Field = " ",
              File = " ",
              Folder = " ",
              Function = " ",
              Interface = " ",
              Key = " ",
              Keyword = " ",
              Method = " ",
              Module = " ",
              Namespace = " ",
              Null = " ",
              Number = " ",
              Object = " ",
              Operator = " ",
              Package = " ",
              Property = " ",
              Reference = " ",
              Snippet = " ",
              String = " ",
              Struct = " ",
              Text = " ",
              TypeParameter = " ",
              Unit = " ",
              Value = " ",
              Variable = " ",
            }
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
      }
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
}
