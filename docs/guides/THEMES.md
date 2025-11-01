# 🎨 Theme Guide

Complete guide to theme customization in Neovim Ultimate Edition.

## Available Themes

### 1. **Catppuccin**
Beautiful pastel theme with 4 flavors.

**Variants:** mocha (dark), macchiato (dark), frappe (dark), latte (light)

**Features:** Transparency support, extensive plugin integrations

```vim
:ThemeSwitch catppuccin mocha
:ThemeSwitch catppuccin latte  " Light variant
```

### 2. **Tokyo Night**
A clean, dark theme inspired by Tokyo's night skyline.

**Variants:** night, storm, moon, day

```vim
:ThemeSwitch tokyonight night
:ThemeSwitch tokyonight day  " Light variant
```

### 3. **Gruvbox**
Retro groove color scheme with warm tones.

**Variants:** dark, light

```vim
:ThemeSwitch gruvbox dark
```

### 4. **Kanagawa**
Dark theme inspired by Katsushika Hokusai's paintings.

**Variants:** wave, dragon, lotus

```vim
:ThemeSwitch kanagawa wave
```

### 5. **Nord**
Arctic, north-bluish color palette.

```vim
:ThemeSwitch nord
```

### 6. **One Dark Pro**
Atom's iconic One Dark theme.

**Variants:** onedark, onelight, onedark_vivid, onedark_dark

```vim
:ThemeSwitch onedark
```

### 7. **Dracula**
Dark theme with vibrant colors.

```vim
:ThemeSwitch dracula
```

### 8. **Rose Pine**
All natural pine, faux fur and a bit of soho vibes.

**Variants:** main, moon, dawn

```vim
:ThemeSwitch rosepine main
```

### 9. **Nightfox**
Highly customizable theme with multiple fox-themed variants.

**Variants:** nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox

```vim
:ThemeSwitch nightfox
:ThemeSwitch dayfox  " Light variant
```

### 10. **Everforest**
Comfortable & pleasant theme for the eyes.

```vim
:ThemeSwitch everforest
```

---

## Commands

### Theme Switching
```vim
:ThemeSwitch <name> [variant]   " Switch to a theme
:ThemePreview                    " Visual picker with Telescope
:ThemeList                       " List all available themes
:ThemeVariant <variant>          " Change current theme's variant
:ThemeRandom                     " Apply random theme (fun!)
```

### Transparency
```vim
:ThemeTransparency on            " Enable transparency
:ThemeTransparency off           " Disable transparency
```

---

## Per-Profile Themes

Set different themes for different profiles in `profile.json`:

```json
{
  "active_profile": "frontend",
  "ui_preferences": {
    "colorscheme": "catppuccin",
    "style": "mocha",
    "transparency": false
  }
}
```

---

## Project-Local Themes

Override theme for a specific project with `.nvim-profile.json`:

```json
{
  "active_profile": "frontend",
  "ui_preferences": {
    "colorscheme": "gruvbox",
    "style": "dark",
    "transparency": true
  }
}
```

---

## Customization

### Using Lua Config
Create `lua/config/custom.lua` (optional):

```lua
return {
  colorscheme = "catppuccin",
  variant = "mocha",
  custom_highlights = {
    Comment = { fg = "#888888", italic = true },
    Function = { fg = "#89b4fa", bold = true },
  },
}
```

### Programmatic Theme Changes
```lua
-- In your config
local theme_manager = require("themes")

-- Apply theme
theme_manager.apply("catppuccin", "mocha", true)

-- Get current theme
local current = theme_manager.current.name

-- List themes
local themes = theme_manager.list()
```

---

## Recommendations

### For Different Profiles

- **Frontend**: Catppuccin Mocha or Tokyo Night
- **Backend**: Gruvbox Dark or Kanagawa
- **Data Science**: Nord or Everforest
- **Writing/Docs**: Rose Pine Dawn or Tokyo Night Day
- **Minimal/Performance**: Tokyo Night (lightweight)

### For Eye Comfort

**Light Themes:**
- Tokyo Night Day
- Catppuccin Latte
- Rose Pine Dawn
- One Light
- Dayfox

**Dark with Less Contrast:**
- Everforest
- Rose Pine Main
- Kanagawa Wave

---

## Troubleshooting

### Theme Not Loading
```vim
:Lazy sync          " Sync all plugins
:ThemeList          " Check if theme is available
```

### Colors Look Wrong
1. Ensure your terminal supports true color
2. Check `echo $TERM` (should be `xterm-256color` or better)
3. Add to your shell config:
   ```bash
   export TERM=xterm-256color
   ```

### Transparency Not Working
- Only some themes support transparency
- Check with `:ThemeList` for [T] indicator
- Ensure your terminal supports transparency

---

## Creating Custom Themes

Advanced users can add custom themes by editing `lua/themes/init.lua`:

```lua
M.themes.mytheme = {
  name = "My Custom Theme",
  plugin = "author/theme-repo",
  module = "mytheme",
  variants = { "dark", "light" },
  default_variant = "dark",
  supports_transparency = true,
  type = "dark",
}
```

---

**Happy theming!** 🎨