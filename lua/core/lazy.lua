-- ══════════════════════════════════════════════════════════════════════
-- Lazy.nvim Bootstrap
-- Automatic installation and setup of lazy.nvim plugin manager
-- ══════════════════════════════════════════════════════════════════════

local M = {}

function M.setup()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  -- Auto-install lazy.nvim if not present
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)

  -- Load lazy.nvim
  require("lazy").setup({
    spec = {
      -- Import plugins based on active profile
      { import = "plugins.themes" },  -- All colorschemes
      { import = "plugins.ui" },
      { import = "plugins.editor" },
      { import = "plugins.git" },
      { import = "plugins.navigation" },
      { import = "plugins.terminal" },
      { import = "plugins.noice" },
      { import = "plugins.session" },
      { import = "plugins.folding" },
      { import = "plugins.search" },
      { import = "plugins.outline" },
      { import = "plugins.markdown" },
      -- LSP plugins (loaded based on profile)
      { import = "plugins.lsp" },
    },
    defaults = {
      lazy = true,  -- Enable lazy-loading by default
      version = false,  -- Don't use version numbers
    },
    install = {
      missing = true,  -- Auto-install missing plugins
      colorscheme = { "tokyonight" },  -- Try this colorscheme during install
    },
    checker = {
      enabled = false,  -- Don't auto-check for updates (performance)
      notify = false,
    },
    change_detection = {
      enabled = true,
      notify = false,  -- Don't notify on config changes
    },
    performance = {
      cache = {
        enabled = true,
      },
      rtp = {
        -- Disable some rtp plugins for performance
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    ui = {
      border = "rounded",
      -- Use safe ASCII icons for compatibility (no Nerd Font required)
      icons = {
        cmd = ">",
        config = "c",
        event = "e",
        ft = "f",
        init = "i",
        import = "m",
        keys = "k",
        lazy = "~",
        loaded = "*",
        not_loaded = "o",
        plugin = "p",
        runtime = "r",
        source = "s",
        start = "s",
        task = "t",
        list = {
          "*",
          ">",
          "+",
          "-",
        },
      },
    },
  })
end

return M
