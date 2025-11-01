# 🎭 Icon Customization Guide

Complete guide to icon management in Neovim Ultimate Edition.

## Icon Sets

### 1. **VSCode Codicons** (Default)
VSCode-like product icons - lightweight and widely supported.

**Best for:** Modern look without requiring special fonts
**Font requirement:** Basic Unicode support
**Size:** Lightweight

```vim
:IconsSet vscode
```

### 2. **Nerd Fonts**
Full nerd font icon set with extensive coverage.

**Best for:** Maximum visual appeal and detail
**Font requirement:** Nerd Font (e.g., Hack Nerd Font, JetBrains Mono Nerd)
**Size:** Comprehensive

```vim
:IconsSet nerd
```

### 3. **Minimal**
Simple ASCII/Unicode icons - no special fonts needed.

**Best for:** Terminals without font support, maximum compatibility
**Font requirement:** None
**Size:** Tiny

```vim
:IconsSet minimal
```

---

## Commands

```vim
:IconsSet <set>       " Switch icon set (vscode, nerd, minimal)
:IconsList            " List all available icon sets
:IconsPreview         " Preview current icon set in popup
```

---

## Icon Categories

### UI Icons
- Files and folders
- Git integration
- Search and navigation
- Settings and tools

### Diagnostic Icons
- Errors
- Warnings
- Hints
- Info messages

### Git Icons
- Add, modify, remove
- Staged/unstaged
- Conflicts
- Branches

### LSP Icons
- Completion kinds
- Symbol types
- Code actions

### Filetype Icons
- 100+ file types
- Language-specific
- Custom extensions

---

## Configuration

### Per-Profile Icon Sets

Set icons in `profile.json`:

```json
{
  "ui_preferences": {
    "icons": "vscode",
    "colorscheme": "catppuccin"
  }
}
```

### Project-Local Icons

Override for specific projects:

```json
{
  "ui_preferences": {
    "icons": "nerd"
  }
}
```

---

## Icon Set Comparison

| Feature | VSCode | Nerd | Minimal |
|---------|--------|------|---------|
| Font Required | Unicode | Nerd Font | None |
| Visual Appeal | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| Compatibility | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Coverage | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Performance | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## Installing Nerd Fonts

### macOS
```bash
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
brew install font-jetbrains-mono-nerd-font
```

### Linux
```bash
# Download
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -fv
```

### Configure Terminal

**iTerm2:**
Preferences → Profiles → Text → Font → Select "JetBrainsMono Nerd Font"

**Alacritty:**
```yaml
font:
  normal:
    family: JetBrainsMono Nerd Font
```

**Kitty:**
```
font_family JetBrainsMono Nerd Font
```

---

## Icon Usage in Plugins

Icons are automatically used by:
- **Lualine** - Statusline icons
- **Bufferline** - Buffer tab icons
- **Neo-tree** - File explorer icons
- **Telescope** - Picker icons
- **nvim-cmp** - Completion menu icons
- **Gitsigns** - Git gutter icons
- **Noice** - Notification icons

---

## Programmatic Access

```lua
-- Get icon manager
local icon_manager = require("icons")

-- Get current icons
local icons = icon_manager.get()

-- Use specific icons
local file_icon = icons.ui.file
local error_icon = icons.diagnostics.error

-- Switch icon set
icon_manager.switch("nerd")

-- Get specific icon
local git_icon = icon_manager.get_icon("git", "branch")
```

---

## Custom Icon Overrides

Advanced: Override specific icons in `lua/config/custom.lua`:

```lua
return {
  icon_overrides = {
    filetypes = {
      lua = "🌙",  -- Custom Lua icon
      python = "🐍",  -- Custom Python icon
    },
    ui = {
      folder = "📁",  -- Custom folder icon
    },
  },
}
```

---

## Recommendations

### For Different Profiles

- **Frontend Developer**: VSCode (familiar)
- **Backend Developer**: Nerd (full featured)
- **Data Science**: VSCode (clean)
- **DevOps**: Nerd (detailed)
- **Minimal Profile**: Minimal (performance)
- **SSH/Remote**: Minimal (compatibility)

### For Terminal Emulators

- **iTerm2**: Nerd or VSCode
- **Alacritty**: VSCode or Nerd
- **Kitty**: VSCode or Nerd
- **Terminal.app**: VSCode
- **SSH**: Minimal
- **TTY**: Minimal

---

## Troubleshooting

### Icons Show as Boxes/Question Marks
1. Install a Nerd Font
2. Configure your terminal to use it
3. Or switch to VSCode/Minimal icon set

### Icons Look Wrong After Switching
```vim
:IconsList          " Verify current set
:IconsSet vscode    " Reset to VSCode
```

### Icons Not Showing in Plugin
- Restart Neovim after icon set change
- Run `:Lazy reload <plugin-name>`
- Check plugin configuration

---

## Examples

### Frontend Developer Setup
```json
{
  "ui_preferences": {
    "icons": "vscode",
    "colorscheme": "catppuccin"
  }
}
```

### Power User Setup
```json
{
  "ui_preferences": {
    "icons": "nerd",
    "colorscheme": "tokyonight"
  }
}
```

### Minimal Setup
```json
{
  "ui_preferences": {
    "icons": "minimal",
    "colorscheme": "gruvbox"
  }
}
```

---

**Enjoy beautiful icons!** 🎭
