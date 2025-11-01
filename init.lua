-- ══════════════════════════════════════════════════════════════════════
-- Neovim Ultimate Edition - Multi-Platform, Profile-Based Configuration
-- GitHub: https://github.com/quadbyte/nvim-ultimate
-- License: MIT
-- Copyright (c) 2024-2025 QuadByte
-- ══════════════════════════════════════════════════════════════════════

-- Performance: Track startup time
local start_time = vim.fn.reltime()

-- ══════════════════════════════════════════════════════════════════════
-- Bootstrap: Load Core Modules
-- ══════════════════════════════════════════════════════════════════════

-- Load editor options (must be first)
require("core.options")

-- Load keymaps
require("core.keymaps")

-- Load autocommands
require("core.autocmds")

-- Initialize profile system
local profile = require("utils.profile")
profile.init()

-- Load lazy.nvim and plugins
require("core.lazy").setup()

-- Load custom commands
require("commands").setup()

-- ══════════════════════════════════════════════════════════════════════
-- Post-Setup
-- ══════════════════════════════════════════════════════════════════════

-- Display startup info
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local platform = require("utils.platform")
    local profile_data = profile.get_profile_data()
    local startup_time = math.floor(vim.fn.reltimefloat(vim.fn.reltime(start_time)) * 1000)

    -- Show startup info (only if not opening a file)
    if vim.fn.argc() == 0 then
      vim.defer_fn(function()
        local info = string.format(
          "⚡ Neovim started in %dms | Profile: %s | Platform: %s %s",
          startup_time,
          profile_data.name,
          platform.get_os(),
          platform.get_arch()
        )
        vim.notify(info, vim.log.levels.INFO)
      end, 100)
    end
  end,
})

-- Global toggle for auto-format
vim.api.nvim_create_user_command("FormatToggle", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  local status = vim.g.disable_autoformat and "disabled" or "enabled"
  vim.notify("Auto-format " .. status, vim.log.levels.INFO)
end, { desc = "Toggle auto-format on save" })
