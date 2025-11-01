-- ══════════════════════════════════════════════════════════════════════
-- Component Manager
-- Modular component system for per-profile customization
-- Each component can be enabled/disabled and configured independently
-- ══════════════════════════════════════════════════════════════════════

local M = {}

-- Available components
M.components = {
  statusline = {
    name = "Statusline",
    description = "Bottom status bar (lualine)",
    enabled = true,
    plugin = "lualine",
    config_key = "statusline",
  },
  tabline = {
    name = "Tabline",
    description = "Buffer tabs at top (bufferline)",
    enabled = true,
    plugin = "bufferline",
    config_key = "tabline",
  },
  explorer = {
    name = "File Explorer",
    description = "File tree sidebar (neo-tree)",
    enabled = true,
    plugin = "neo-tree",
    config_key = "explorer",
  },
  terminal = {
    name = "Terminal",
    description = "Integrated terminal (toggleterm)",
    enabled = true,
    plugin = "toggleterm",
    config_key = "terminal",
  },
  git_signs = {
    name = "Git Signs",
    description = "Git diff in gutter (gitsigns)",
    enabled = true,
    plugin = "gitsigns",
    config_key = "git_signs",
  },
  completion = {
    name = "Completion",
    description = "Auto-completion (nvim-cmp)",
    enabled = true,
    plugin = "cmp",
    config_key = "completion",
  },
  diagnostics = {
    name = "Diagnostics",
    description = "LSP diagnostics display",
    enabled = true,
    config_key = "diagnostics",
  },
  notifications = {
    name = "Notifications",
    description = "UI notifications (noice + notify)",
    enabled = true,
    plugin = "noice",
    config_key = "notifications",
  },
  outline = {
    name = "Code Outline",
    description = "Symbol outline (aerial)",
    enabled = true,
    plugin = "aerial",
    config_key = "outline",
  },
}

-- Get component configuration from profile
function M.get_config(component_name)
  local profile = require("utils.profile")
  local profile_data = profile.get_profile_data()

  -- Check if profile has component configuration
  if profile_data.components and profile_data.components[component_name] then
    return profile_data.components[component_name]
  end

  -- Return default
  local component = M.components[component_name]
  return component and { enabled = component.enabled } or { enabled = false }
end

-- Check if component is enabled
function M.is_enabled(component_name)
  local config = M.get_config(component_name)
  return config.enabled ~= false
end

-- Toggle component
function M.toggle(component_name)
  if not M.components[component_name] then
    vim.notify("Component not found: " .. component_name, vim.log.levels.ERROR)
    return false
  end

  local config = M.get_config(component_name)
  config.enabled = not config.enabled

  -- Save to profile
  local profile = require("utils.profile")
  local profile_data = profile.get_profile_data()

  if not profile_data.components then
    profile_data.components = {}
  end

  profile_data.components[component_name] = config

  -- Note: This requires profile saving to be implemented
  vim.notify(
    M.components[component_name].name .. " " .. (config.enabled and "enabled" or "disabled") .. ". Restart Neovim to apply.",
    vim.log.levels.INFO
  )

  return true
end

-- List all components
function M.list()
  local components = {}
  for key, component in pairs(M.components) do
    local config = M.get_config(key)
    table.insert(components, {
      key = key,
      name = component.name,
      description = component.description,
      enabled = config.enabled,
      plugin = component.plugin,
    })
  end
  return components
end

-- Get component settings
function M.get_settings(component_name)
  local config = M.get_config(component_name)
  return config.settings or {}
end

-- Set component settings
function M.set_settings(component_name, settings)
  local config = M.get_config(component_name)
  config.settings = vim.tbl_extend("force", config.settings or {}, settings)

  -- Save to profile would go here
  vim.notify("Settings updated for: " .. M.components[component_name].name, vim.log.levels.INFO)
end

return M
