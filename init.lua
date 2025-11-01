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

-- Display startup info (only for slow startups or when no file is opened)
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local startup_time = math.floor(vim.fn.reltimefloat(vim.fn.reltime(start_time)) * 1000)

    -- Only show notification if startup is slow (>100ms) or no files opened
    if vim.fn.argc() == 0 and startup_time > 100 then
      vim.defer_fn(function()
        local profile_data = profile.get_profile_data()
        local info = string.format("⚡ Neovim started in %dms | Profile: %s", startup_time, profile_data.name)
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
