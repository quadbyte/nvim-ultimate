-- ══════════════════════════════════════════════════════════════════════
-- Icon Manager
-- Centralized icon management with multiple icon sets
-- Supports: VSCode codicons, Nerd Fonts, Minimal
-- ══════════════════════════════════════════════════════════════════════

local M = {}

-- Available icon sets
M.sets = {
  vscode = {
    name = "VSCode Codicons",
    description = "VSCode-like product icons (lightweight)",
    module = "icons.vscode",
  },
  nerd = {
    name = "Nerd Fonts",
    description = "Full nerd font icons (requires nerd font)",
    module = "icons.nerd",
  },
  minimal = {
    name = "Minimal",
    description = "Simple ASCII/Unicode icons",
    module = "icons.minimal",
  },
}

-- Current icon set
M.current_set = "vscode"

-- Cached icons
M.cache = nil

-- Load icon configuration from profile
function M.load_config()
  local profile_manager = require("utils.profile")
  local config = profile_manager.load_config()

  if config.ui_preferences and config.ui_preferences.icons then
    return config.ui_preferences.icons
  end

  return "vscode"
end

-- Save icon configuration
function M.save_config(icon_set)
  local profile_manager = require("utils.profile")
  local config = profile_manager.load_config()

  if not config.ui_preferences then
    config.ui_preferences = {}
  end

  config.ui_preferences.icons = icon_set
  profile_manager.save_config(config)
end

-- Load icon set
function M.load(set_name)
  set_name = set_name or M.load_config()

  if not M.sets[set_name] then
    vim.notify("Icon set not found: " .. set_name, vim.log.levels.ERROR)
    set_name = "vscode" -- Fallback
  end

  local ok, icons = pcall(require, M.sets[set_name].module)
  if not ok then
    vim.notify("Failed to load icon set: " .. set_name, vim.log.levels.ERROR)
    return nil
  end

  M.current_set = set_name
  M.cache = icons
  M.save_config(set_name)

  return icons
end

-- Get icons (lazy load)
function M.get()
  if not M.cache then
    M.load()
  end
  return M.cache
end

-- Switch icon set
function M.switch(set_name)
  if not M.sets[set_name] then
    vim.notify("Icon set not found: " .. set_name, vim.log.levels.ERROR)
    return false
  end

  M.load(set_name)
  vim.notify("Icon set switched to: " .. M.sets[set_name].name, vim.log.levels.INFO)

  -- Reload UI components that use icons
  vim.schedule(function()
    vim.cmd("redrawstatus!")
    -- Trigger lazy reload for components
    pcall(function()
      require("lualine").setup()
    end)
  end)

  return true
end

-- List available icon sets
function M.list()
  local sets = {}
  for key, set in pairs(M.sets) do
    table.insert(sets, {
      key = key,
      name = set.name,
      description = set.description,
      active = key == M.current_set,
    })
  end
  return sets
end

-- Get icon for specific type
function M.get_icon(type, name)
  local icons = M.get()
  if not icons or not icons[type] then
    return ""
  end
  return icons[type][name] or ""
end

return M
