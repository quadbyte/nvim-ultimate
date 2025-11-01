-- ══════════════════════════════════════════════════════════════════════
-- Theme Manager
-- Centralized theme management with multiple colorscheme support
-- ══════════════════════════════════════════════════════════════════════

local M = {}

-- Theme registry with metadata
M.themes = {
  catppuccin = {
    name = "Catppuccin",
    plugin = "catppuccin/nvim",
    module = "catppuccin",
    variants = { "mocha", "macchiato", "frappe", "latte" },
    default_variant = "mocha",
    supports_transparency = true,
    type = "dark", -- primary type
  },
  tokyonight = {
    name = "Tokyo Night",
    plugin = "folke/tokyonight.nvim",
    module = "tokyonight",
    variants = { "night", "storm", "day", "moon" },
    default_variant = "night",
    supports_transparency = true,
    type = "dark",
  },
  gruvbox = {
    name = "Gruvbox",
    plugin = "ellisonleao/gruvbox.nvim",
    module = "gruvbox",
    variants = { "dark", "light" },
    default_variant = "dark",
    supports_transparency = true,
    type = "dark",
  },
  kanagawa = {
    name = "Kanagawa",
    plugin = "rebelot/kanagawa.nvim",
    module = "kanagawa",
    variants = { "wave", "dragon", "lotus" },
    default_variant = "wave",
    supports_transparency = true,
    type = "dark",
  },
  nord = {
    name = "Nord",
    plugin = "shaunsingh/nord.nvim",
    module = "nord",
    variants = {},
    supports_transparency = false,
    type = "dark",
  },
  onedark = {
    name = "One Dark Pro",
    plugin = "olimorris/onedarkpro.nvim",
    module = "onedarkpro",
    variants = { "onedark", "onelight", "onedark_vivid", "onedark_dark" },
    default_variant = "onedark",
    supports_transparency = true,
    type = "dark",
  },
  dracula = {
    name = "Dracula",
    plugin = "Mofiqul/dracula.nvim",
    module = "dracula",
    variants = {},
    supports_transparency = true,
    type = "dark",
  },
  rosepine = {
    name = "Rose Pine",
    plugin = "rose-pine/neovim",
    module = "rose-pine",
    variants = { "main", "moon", "dawn" },
    default_variant = "main",
    supports_transparency = true,
    type = "dark",
  },
  nightfox = {
    name = "Nightfox",
    plugin = "EdenEast/nightfox.nvim",
    module = "nightfox",
    variants = { "nightfox", "dayfox", "dawnfox", "duskfox", "nordfox", "terafox", "carbonfox" },
    default_variant = "nightfox",
    supports_transparency = true,
    type = "dark",
  },
  everforest = {
    name = "Everforest",
    plugin = "sainnhe/everforest",
    module = nil, -- Uses vim commands
    variants = {},
    supports_transparency = false,
    type = "dark",
  },
}

-- Current theme state
M.current = {
  name = nil,
  variant = nil,
}

-- Load theme configuration from profile
function M.load_config()
  local profile_manager = require("utils.profile")
  local config = profile_manager.load_config()

  if config.ui_preferences then
    return {
      colorscheme = config.ui_preferences.colorscheme or "tokyonight",
      variant = config.ui_preferences.style or nil,
      transparency = config.ui_preferences.transparency or false,
    }
  end

  return {
    colorscheme = "tokyonight",
    variant = "night",
    transparency = false,
  }
end

-- Save theme configuration to profile
function M.save_config(theme_name, variant, transparency)
  local profile_manager = require("utils.profile")
  local config = profile_manager.load_config()

  if not config.ui_preferences then
    config.ui_preferences = {}
  end

  config.ui_preferences.colorscheme = theme_name
  config.ui_preferences.style = variant
  config.ui_preferences.transparency = transparency or false

  profile_manager.save_config(config)
end

-- Apply theme with variant
function M.apply(theme_name, variant, transparency)
  local theme = M.themes[theme_name]
  if not theme then
    vim.notify("Theme not found: " .. theme_name, vim.log.levels.ERROR)
    return false
  end

  -- Apply transparency if supported
  transparency = transparency and theme.supports_transparency

  -- Theme-specific setup
  if theme_name == "catppuccin" then
    require("catppuccin").setup({
      flavour = variant or theme.default_variant,
      transparent_background = transparency or false,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = { enabled = true },
        telescope = { enabled = true },
        which_key = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  elseif theme_name == "tokyonight" then
    require("tokyonight").setup({
      style = variant or theme.default_variant,
      transparent = transparency or false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
    })
    vim.cmd.colorscheme("tokyonight")
  elseif theme_name == "gruvbox" then
    require("gruvbox").setup({
      transparent_mode = transparency or false,
      contrast = variant or "medium",
    })
    vim.cmd.colorscheme("gruvbox")
  elseif theme_name == "kanagawa" then
    require("kanagawa").setup({
      theme = variant or theme.default_variant,
      transparent = transparency or false,
    })
    vim.cmd.colorscheme("kanagawa")
  elseif theme_name == "nord" then
    if transparency then
      vim.g.nord_transparent = true
    end
    vim.cmd.colorscheme("nord")
  elseif theme_name == "onedark" then
    require("onedarkpro").setup({
      colors = {},
      highlights = {},
      styles = {
        types = "NONE",
        methods = "NONE",
        numbers = "NONE",
        strings = "NONE",
        comments = "italic",
        keywords = "bold,italic",
        constants = "NONE",
        functions = "italic",
        operators = "NONE",
        variables = "NONE",
        parameters = "NONE",
        conditionals = "italic",
        virtual_text = "NONE",
      },
      options = {
        bold = true,
        italic = true,
        underline = true,
        undercurl = true,
        cursorline = false,
        transparency = transparency or false,
        terminal_colors = true,
        window_unfocused_color = false,
      },
    })
    vim.cmd.colorscheme(variant or theme.default_variant)
  elseif theme_name == "dracula" then
    require("dracula").setup({
      transparent_bg = transparency or false,
      italic_comment = true,
    })
    vim.cmd.colorscheme("dracula")
  elseif theme_name == "rosepine" then
    require("rose-pine").setup({
      variant = variant or theme.default_variant,
      disable_background = transparency or false,
      disable_float_background = transparency or false,
    })
    vim.cmd.colorscheme("rose-pine")
  elseif theme_name == "nightfox" then
    require("nightfox").setup({
      options = {
        transparent = transparency or false,
        terminal_colors = true,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
    })
    vim.cmd.colorscheme(variant or theme.default_variant)
  elseif theme_name == "everforest" then
    vim.g.everforest_background = variant or "medium"
    if transparency then
      vim.g.everforest_transparent_background = 1
    end
    vim.cmd.colorscheme("everforest")
  end

  -- Update current state
  M.current.name = theme_name
  M.current.variant = variant

  -- Save to profile
  M.save_config(theme_name, variant, transparency)

  vim.notify("Theme applied: " .. theme.name .. (variant and (" (" .. variant .. ")") or ""), vim.log.levels.INFO)
  return true
end

-- Load theme from profile on startup
function M.load_from_profile()
  local config = M.load_config()
  M.apply(config.colorscheme, config.variant, config.transparency)
end

-- Get all available themes
function M.list()
  local themes = {}
  for key, theme in pairs(M.themes) do
    table.insert(themes, {
      key = key,
      name = theme.name,
      type = theme.type,
      variants = #theme.variants > 0 and theme.variants or nil,
      supports_transparency = theme.supports_transparency,
    })
  end
  return themes
end

-- Get theme info
function M.get_info(theme_name)
  return M.themes[theme_name]
end

-- Random theme selector
function M.random()
  local themes = vim.tbl_keys(M.themes)
  local random_theme = themes[math.random(#themes)]
  local theme = M.themes[random_theme]

  local variant = nil
  if #theme.variants > 0 then
    variant = theme.variants[math.random(#theme.variants)]
  end

  M.apply(random_theme, variant, false)
end

return M
