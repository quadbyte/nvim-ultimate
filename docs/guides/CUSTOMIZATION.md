# ⚙️ Customization Guide

Complete guide to customizing Neovim Ultimate Edition.

## Table of Contents
- [Profile Customization](#profile-customization)
- [Theme & Icons](#theme--icons)
- [Component System](#component-system)
- [UI Preferences](#ui-preferences)
- [Plugin Configuration](#plugin-configuration)
- [Custom Commands](#custom-commands)
- [Advanced Customization](#advanced-customization)

---

## Profile Customization

### Creating Custom Profiles

**Method 1: Clone Existing Profile**
```vim
:ProfileClone backend mybackend
```

**Method 2: Edit profile.json**
```json
{
  "active_profile": "myprofile",
  "profiles": {
    "myprofile": {
      "name": "My Custom Profile",
      "description": "Tailored to my needs",
      "base": "fullstack",
      "languages": ["python", "javascript", "go"],
      "lsp_servers": ["pyright", "ts_ls", "gopls"],
      "formatters": ["black", "prettier", "gofmt"],
      "linters": ["pylint", "eslint_d"]
    }
  }
}
```

### Project-Local Profiles

Create `.nvim-profile.json` in project root:
```json
{
  "active_profile": "frontend",
  "ui_preferences": {
    "colorscheme": "catppuccin",
    "icons": "vscode"
  },
  "components": {
    "tabline": {
      "enabled": false
    }
  }
}
```

Or use command:
```vim
:ProfileCreateLocal
```

---

## Theme & Icons

### Theme Customization

**Quick Switch:**
```vim
:ThemePreview           " Visual picker
:ThemeSwitch catppuccin mocha
```

**Per-Profile Theme:**
```json
{
  "ui_preferences": {
    "colorscheme": "tokyonight",
    "style": "night",
    "transparency": false
  }
}
```

### Icon Customization

**Switch Icon Set:**
```vim
:IconsSet vscode    " VSCode codicons
:IconsSet nerd      " Nerd fonts
:IconsSet minimal   " Simple ASCII
```

**In profile.json:**
```json
{
  "ui_preferences": {
    "icons": "vscode"
  }
}
```

---

## Component System

### What are Components?

Components are modular features that can be toggled:
- Statusline (lualine)
- Tabline (bufferline)
- File Explorer (neo-tree)
- Terminal (toggleterm)
- Git Signs (gitsigns)
- Completion (nvim-cmp)
- Diagnostics
- Notifications (noice)
- Outline (aerial)

### Component Commands

```vim
:ComponentList              " List all components
:ComponentToggle explorer   " Toggle file explorer
:ComponentInfo statusline   " Show component info
```

### Component Configuration

```json
{
  "components": {
    "statusline": {
      "enabled": true,
      "style": "powerline"
    },
    "tabline": {
      "enabled": false
    },
    "explorer": {
      "enabled": true,
      "width": 40,
      "position": "left"
    },
    "terminal": {
      "enabled": true,
      "position": "float"
    },
    "completion": {
      "enabled": true,
      "ghost_text": true
    },
    "diagnostics": {
      "enabled": true,
      "virtual_text": true,
      "signs": true
    }
  }
}
```

---

## UI Preferences

### Complete UI Configuration

```json
{
  "ui_preferences": {
    "colorscheme": "catppuccin",
    "style": "mocha",
    "transparency": false,
    "icons": "vscode",
    "borders": "rounded",
    "layout": {
      "sidebar_width": 30,
      "cmdheight": 1,
      "laststatus": 3
    }
  }
}
```

### Border Styles
- `single` - Single line
- `double` - Double line
- `rounded` - Rounded corners
- `solid` - Solid block
- `none` - No borders

---

## Plugin Configuration

### Disabling Plugins Per-Profile

```json
{
  "plugins": {
    "disabled": ["noice", "flash", "aerial"]
  }
}
```

### Plugin-Specific Settings

**Statusline:**
```json
{
  "components": {
    "statusline": {
      "enabled": true,
      "style": "minimal",
      "show_diagnostics": true,
      "show_git": true
    }
  }
}
```

**Explorer:**
```json
{
  "components": {
    "explorer": {
      "enabled": true,
      "width": 35,
      "position": "left",
      "show_hidden": false,
      "follow_current_file": true
    }
  }
}
```

---

## Custom Commands

### Quick Editing

```vim
:EditConfig         " Edit init.lua
:EditProfiles       " Edit profile.lua
:EditKeymaps        " Edit keymaps.lua
```

### Utility Commands

```vim
:CopyPath           " Copy current file path
:ClearCache         " Clear all cache
:UpdatePlugins      " Update all plugins
```

---

## Advanced Customization

### Custom Lua Configuration

Create `lua/config/custom.lua` (optional):

```lua
return {
  -- Override colorscheme
  colorscheme = "gruvbox",

  -- Custom keymaps
  keymaps = {
    { "n", "<leader>cc", "<cmd>MyCustomCommand<cr>", { desc = "My Command" } },
  },

  -- Custom highlights
  highlights = {
    Comment = { fg = "#888888", italic = true },
    Function = { fg = "#89b4fa", bold = true },
  },

  -- Custom icons
  icons = {
    lua = "",
    python = "",
  },

  -- Plugin overrides
  plugins = {
    lualine = {
      options = {
        theme = "auto",
      },
    },
  },
}
```

### Profile Inheritance

```lua
-- In lua/utils/profile.lua
M.profiles.myprofile = {
  name = "My Profile",
  description = "Based on fullstack",
  base = "fullstack",  -- Inherit from fullstack

  -- Override specific settings
  languages = { "python", "javascript" },
  lsp_servers = { "pyright", "ts_ls" },

  components = {
    tabline = { enabled = false },
  },

  ui = {
    colorscheme = "nord",
  },
}
```

### Adding Custom Themes

Edit `lua/themes/init.lua`:

```lua
M.themes.mytheme = {
  name = "My Custom Theme",
  plugin = "author/mytheme.nvim",
  module = "mytheme",
  variants = { "dark", "light" },
  default_variant = "dark",
  supports_transparency = true,
  type = "dark",
}
```

---

## Example Configurations

### 1. Frontend Developer
```json
{
  "active_profile": "frontend",
  "ui_preferences": {
    "colorscheme": "catppuccin",
    "style": "mocha",
    "icons": "vscode",
    "transparency": false
  },
  "components": {
    "statusline": { "enabled": true },
    "tabline": { "enabled": true },
    "explorer": { "enabled": true, "width": 30 },
    "terminal": { "enabled": true, "position": "float" }
  }
}
```

### 2. Minimal Setup (Performance)
```json
{
  "active_profile": "minimal",
  "ui_preferences": {
    "colorscheme": "tokyonight",
    "style": "night",
    "icons": "minimal",
    "transparency": false
  },
  "components": {
    "statusline": { "enabled": true, "style": "minimal" },
    "tabline": { "enabled": false },
    "explorer": { "enabled": false },
    "notifications": { "enabled": false }
  }
}
```

### 3. Power User (All Features)
```json
{
  "active_profile": "fullstack",
  "ui_preferences": {
    "colorscheme": "catppuccin",
    "style": "mocha",
    "icons": "nerd",
    "transparency": true,
    "borders": "rounded"
  },
  "components": {
    "statusline": { "enabled": true, "style": "powerline" },
    "tabline": { "enabled": true },
    "explorer": { "enabled": true, "width": 40 },
    "terminal": { "enabled": true },
    "git_signs": { "enabled": true },
    "completion": { "enabled": true, "ghost_text": true },
    "diagnostics": { "enabled": true, "virtual_text": true },
    "notifications": { "enabled": true },
    "outline": { "enabled": true }
  }
}
```

---

## Best Practices

### 1. Start with a Base Profile
Don't create from scratch - clone and modify:
```vim
:ProfileClone frontend myprofile
```

### 2. Use Project-Local Profiles
For project-specific settings:
```vim
:ProfileCreateLocal
```

### 3. Test Before Committing
```vim
:ThemePreview       " Test themes visually
:ComponentToggle    " Test component changes
:ProfileValidate    " Validate configuration
```

### 4. Keep Backups
Before major changes:
```bash
cp ~/.config/nvim/profile.json ~/.config/nvim/profile.json.backup
```

### 5. Document Your Changes
Add comments in `profile.json`:
```json
{
  "_comment": "Custom config for React projects",
  "active_profile": "frontend"
}
```

---

## Troubleshooting

### Changes Not Applied
```vim
:source ~/.config/nvim/init.lua   " Reload config
```
Or restart Neovim.

### Profile Validation Errors
```vim
:ProfileValidate    " Check for errors
```

### Reset to Defaults
```bash
rm ~/.config/nvim/profile.json
cp ~/.config/nvim/profile.json.backup ~/.config/nvim/profile.json
```

---

## More Resources

- [THEMES.md](THEMES.md) - Complete theme guide
- [ICONS.md](ICONS.md) - Icon customization
- [KEYBINDINGS.md](KEYBINDINGS.md) - All keybindings
- [README.md](README.md) - Main documentation

---

**Make it yours!** ⚙️