# 🚀 Neovim Ultimate Edition

> **Multi-platform, profile-based Neovim configuration for professional developers**

A high-performance, modular Neovim distribution designed for developers working across multiple companies, projects, and tech stacks. Load only what you need, switch profiles instantly, and enjoy blazing-fast startup times.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20WSL-blue)](#)

## ✨ Features

### 🎯 Profile-Based Configuration
Choose your profile, load only relevant plugins and LSP servers:
- **Frontend**: JavaScript/TypeScript, React, Vue, Tailwind
- **Backend**: Python, Go, Rust, Node.js, SQL
- **Mobile**: React Native, Flutter, Swift, Kotlin
- **Data Engineer**: Python, SQL, R, Jupyter
- **DevOps**: Bash, Docker, Kubernetes, Terraform
- **Full Stack**: Combined frontend + backend
- **Minimal**: Lightweight core only

### ⚡ Performance-Optimized
- **Startup time**: 20-80ms depending on profile
- **Memory usage**: 50-250MB based on profile
- **Lazy loading**: Everything loads on-demand
- **Minimal profile**: <50ms startup, <80MB RAM

### 🌍 Multi-Platform Support
- **macOS** (ARM64 & Intel)
- **Linux** (Ubuntu, Arch, Fedora, etc.)
- **Windows WSL2**

### 🔧 Professional Features
- 50+ carefully selected plugins
- 11+ LSP servers (profile-dependent)
- Auto-formatting on save
- Git integration (gitsigns, lazygit)
- Fuzzy finding (Telescope)
- File explorer (Neo-tree)
- Smart completion (nvim-cmp)
- Beautiful UI (Tokyo Night theme + Noice.nvim)
- Integrated terminal
- Session management (per-project)
- Profile switching with Telescope picker
- Project-local profile support
- Code outline (Aerial)
- Advanced search/replace (Spectre)
- Better folding (UFO)
- Health check system
- Performance benchmarking

## 📦 Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/quadbyte/nvim-ultimate.git ~/.config/nvim-ultimate

# Run the installer
cd ~/.config/nvim-ultimate
./install.sh
```

The installer will:
1. Detect your platform (macOS/Linux/WSL)
2. Ask you to choose a profile
3. Install required dependencies
4. Back up existing configuration
5. Deploy the new configuration
6. Install all plugins

### Manual Installation

```bash
# 1. Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# 2. Clone this repo
git clone https://github.com/quadbyte/nvim-ultimate.git ~/.config/nvim

# 3. Install dependencies (example for macOS)
brew install neovim git node ripgrep fd fzf lazygit

# 4. Create profile config
cat > ~/.config/nvim/profile.json << EOF
{
  "active_profile": "fullstack",
  "performance_mode": "balanced"
}
EOF

# 5. Launch Neovim (plugins will auto-install)
nvim
```

## 🎨 Profiles

### Profile Comparison

| Profile | Languages | LSP Servers | Startup Time | Memory Usage |
|---------|-----------|-------------|--------------|--------------|
| Minimal | 0-2 | 0-2 | ~20ms | ~50MB |
| Frontend | 5 | 5 | ~40ms | ~120MB |
| Backend | 6 | 6 | ~50ms | ~150MB |
| Mobile | 5 | 4 | ~45ms | ~130MB |
| Data | 5 | 5 | ~45ms | ~140MB |
| DevOps | 5 | 5 | ~40ms | ~110MB |
| Full Stack | 12+ | 10+ | ~80ms | ~200MB |

### Switch Profiles

```vim
" In Neovim command mode
:ProfileSwitch frontend
:ProfileInfo
:ProfileList
```

Or edit `~/.config/nvim/profile.json`:

```json
{
  "active_profile": "backend",
  "performance_mode": "balanced"
}
```

Restart Neovim to apply changes.

## 📚 Documentation

### Project Structure

```
~/.config/nvim/
├── init.lua                    # Entry point (minimal, ~50 lines)
├── profile.json                # Profile configuration
└── lua/
    ├── core/
    │   ├── options.lua         # Editor settings
    │   ├── keymaps.lua         # Core keybindings
    │   ├── autocmds.lua        # Auto commands
    │   └── lazy.lua            # Plugin manager setup
    ├── utils/
    │   ├── platform.lua        # Multi-platform support
    │   ├── helpers.lua         # Utility functions
    │   └── profile.lua         # Profile system
    └── plugins/
        ├── ui.lua              # Visual plugins
        ├── editor.lua          # Editing tools
        ├── navigation.lua      # File explorer, fuzzy finder
        ├── git.lua             # Git integration
        ├── terminal.lua        # Terminal integration
        └── lsp/
            └── init.lua        # LSP configuration
```

### Key Bindings

#### Core Operations
| Key | Action |
|-----|--------|
| `<Space>` | Leader key (wait to see all bindings) |
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Tab>` | Next buffer |
| `<Shift-Tab>` | Previous buffer |

#### File Navigation
| Key | Action |
|-----|--------|
| `<Space>e` | Toggle file explorer |
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep (search in files) |
| `<Space>fb` | Find buffers |
| `<Space>fr` | Recent files |

#### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Show references |
| `K` | Hover documentation |
| `<Space>lr` | Rename symbol |
| `<Space>la` | Code actions |
| `<Space>lf` | Format code |
| `[d / ]d` | Previous/Next diagnostic |

#### Git
| Key | Action |
|-----|--------|
| `<Space>gg` | LazyGit |
| `<Space>gp` | Preview hunk |
| `<Space>gr` | Reset hunk |
| `[h / ]h` | Previous/Next hunk |

#### Terminal
| Key | Action |
|-----|--------|
| `<Ctrl-\>` | Toggle terminal |
| `<Space>tf` | Float terminal |
| `<Esc><Esc>` | Exit terminal mode |

## 🎯 Use Cases

### Frontend Developer @ Company A
```json
{
  "active_profile": "frontend"
}
```
Loads: TypeScript, React, Vue, Tailwind, ESLint, Prettier

### Backend Developer @ Company B
```json
{
  "active_profile": "backend"
}
```
Loads: Python, Go, Rust, Docker, SQL

### Switching Between Projects
```vim
:ProfileSwitch mobile      " Working on React Native app
:ProfileSwitch backend     " Switching to Python API
:ProfileSwitch fullstack   " Full-stack project
```

### Low-Resource Machine
```json
{
  "active_profile": "minimal",
  "performance_mode": "fast"
}
```
Minimal footprint: ~20ms startup, ~50MB RAM

## 🔧 Customization

### Add Your Own Profile

Edit `lua/utils/profile.lua`:

```lua
M.profiles.myprofile = {
  name = "My Custom Profile",
  description = "My specific needs",
  languages = { "rust", "go", "typescript" },
  lsp_servers = { "rust_analyzer", "gopls", "ts_ls" },
  formatters = { "rustfmt", "gofmt", "prettier" },
  linters = {},
}
```

### Disable Auto-Format

```vim
:FormatToggle
```

Or set globally:
```lua
vim.g.disable_autoformat = true
```

### Add Custom Keymaps

Edit `lua/core/keymaps.lua`:

```lua
vim.keymap.set("n", "<leader>cc", "<cmd>YourCommand<cr>", { desc = "Your command" })
```

## 🎨 New Features (v2.0 - Theme & Customization Update)

### 🌈 **10+ Colorscheme Support**
```vim
:ThemePreview           " Visual theme picker
:ThemeSwitch catppuccin mocha
:ThemeList              " See all themes
```

**Available Themes:**
- Catppuccin (4 variants)
- Tokyo Night (4 variants)
- Gruvbox
- Kanagawa
- Nord
- One Dark Pro
- Dracula
- Rose Pine
- Nightfox (7 variants!)
- Everforest

### 🎭 **VSCode-Like Icon System**
```vim
:IconsSet vscode        " VSCode codicons (default)
:IconsSet nerd          " Nerd fonts (rich)
:IconsSet minimal       " ASCII/Unicode (lightweight)
:IconsPreview           " See current icons
```

**Three Icon Sets:**
- **VSCode**: Modern, lightweight, no special fonts needed
- **Nerd**: Beautiful, requires Nerd Font installed
- **Minimal**: Simple ASCII, maximum compatibility

### 🔧 **Component System**
```vim
:ComponentToggle explorer   " Enable/disable components
:ComponentList              " See all components
```

**Modular Components:**
- Statusline, Tabline, Explorer, Terminal
- Git Signs, Completion, Diagnostics
- Notifications, Outline
- Each can be toggled per-profile!

### Project-Local Profiles
Create a `.nvim-profile.json` in your project root to override the global profile:

```json
{
  "active_profile": "frontend",
  "description": "React project"
}
```

Or use the command:
```vim
:ProfileCreateLocal
```

### Profile Management Commands
```vim
:ProfilePicker          " Telescope picker for profiles
:ProfileBench           " Benchmark all profiles
:ProfileClone <src> <dst>  " Clone and customize a profile
:ProfileValidate        " Validate current profile
:ProfileInfo            " Show detailed profile info
```

### Session Management
```vim
:lua require("persistence").load()  " Restore last session
<leader>qs              " Restore session
<leader>ql              " Restore last session
<leader>qd              " Don't save current session
```

### Code Navigation
```vim
:AerialToggle           " Toggle code outline
<leader>cs              " Code structure sidebar
<leader>sr              " Search and replace (Spectre)
]]                      " Next reference (illuminate)
[[                      " Previous reference (illuminate)
```

### Health & Diagnostics
```vim
:NvimUltimateHealth     " Comprehensive health check
:checkhealth            " Built-in health check
:StartupTime            " Show startup time breakdown
```

### Utility Commands
```vim
:EditConfig             " Quick edit init.lua
:EditProfiles           " Edit profile configuration
:EditKeymaps            " Edit keymaps
:CopyPath [full|relative|name]  " Copy file path
:ClearCache             " Clear all cache files
:UpdatePlugins          " Update all plugins
```

## 🚀 Performance Tips

1. **Use appropriate profile**: Don't use `fullstack` if you only need `frontend`
2. **Lazy loading**: Most plugins load on-demand (check `:Lazy`)
3. **Project-local profiles**: Use `.nvim-profile.json` for per-project configs
4. **Benchmark profiles**: Run `:ProfileBench` to see load times
5. **Check startup time**: Run `nvim --startuptime startup.log` or `:StartupTime`
6. **Profile switching**: Switch to `minimal` for quick edits
7. **Disable unused features**: Comment out plugins you don't need in `lua/plugins/`

## 🔍 Troubleshooting

### Plugins Not Loading
```vim
:Lazy sync              " Sync all plugins
:Lazy restore           " Restore from lock file
:Lazy clean             " Remove unused plugins
```

### LSP Not Working
```vim
:LspInfo                " Check LSP status
:Mason                  " Install/update LSP servers
:NvimUltimateHealth     " Run health check
```

### Slow Startup
```vim
:ProfileBench           " Benchmark profiles
:StartupTime            " See what's slow
```

Try switching to a lighter profile or use:
```json
{
  "active_profile": "minimal"
}
```

### Profile Not Switching
1. Check `~/.config/nvim/profile.json` exists
2. Run `:ProfileValidate` to check for errors
3. Restart Neovim after switching profiles
4. Check for `.nvim-profile.json` in project root (overrides global)

### Commands Not Found
```bash
# Reload configuration
:source ~/.config/nvim/init.lua

# Or restart Neovim
```

### Clear All Cache and Start Fresh
```bash
# Inside Neovim
:ClearCache

# Or manually
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
```

## ❓ FAQ

### Q: How do I update to the latest version?
```bash
cd ~/.config/nvim
./update.sh

# Or manually
git pull origin main
nvim --headless "+Lazy! sync" +qa
```

### Q: Can I use my own colorscheme?
Yes! Edit `lua/plugins/ui.lua` and change the colorscheme plugin, or add:
```lua
-- In lua/plugins/ui.lua
return {
  "your-colorscheme/repo",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("your-colorscheme")
  end,
}
```

### Q: How do I add a custom LSP server?
Edit your profile in `lua/utils/profile.lua`:
```lua
M.profiles.myprofile = {
  name = "My Profile",
  description = "Custom setup",
  languages = { "rust", "go" },
  lsp_servers = { "rust_analyzer", "gopls", "my_custom_lsp" },
  formatters = { "rustfmt", "gofmt" },
  linters = {},
}
```

### Q: Can I use this with NvChad/LazyVim?
This is a standalone configuration. It's not designed to be used with other distributions, but you can take inspiration from the profile system.

### Q: How do I disable auto-format on save?
```vim
:FormatToggle           " Toggle globally

" Or in profile.json
{
  "custom_settings": {
    "format_on_save": false
  }
}
```

### Q: Which profile should I use?
- **Frontend**: JavaScript/TypeScript projects
- **Backend**: Python, Go, Rust server development
- **Mobile**: React Native, Flutter apps
- **Data**: Jupyter notebooks, data analysis
- **DevOps**: Infrastructure, scripts, containers
- **Full Stack**: When you need everything
- **Minimal**: Fast, lightweight, minimal features

### Q: Can I create a profile per company/client?
Yes! Use profile inheritance:
```vim
:lua require("utils.profile").extend_profile("backend", "company_a", {
  lsp_servers = { "pyright", "gopls", "custom_lsp" }
})
```

Or create a `.nvim-profile.json` in each project.

### Q: How do I uninstall?
```bash
cd ~/.config/nvim
./uninstall.sh

# Or manually
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim  # Optional: removes plugins
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📖 Additional Documentation

- [KEYBINDINGS.md](KEYBINDINGS.md) - Complete keybinding reference
- [THEMES.md](THEMES.md) - Theme customization guide (10+ themes)
- [ICONS.md](ICONS.md) - Icon system guide (VSCode, Nerd, Minimal)
- [CUSTOMIZATION.md](CUSTOMIZATION.md) - Complete customization guide
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

Built on top of excellent open-source projects:
- [Neovim](https://neovim.io/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [LazyVim](https://www.lazyvim.org/) (inspiration)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

**Icon Sets:**
- [VSCode Codicons](https://github.com/microsoft/vscode-codicons) (MIT License)
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) (MIT License)

**Theme Plugins:**
- [Catppuccin](https://github.com/catppuccin/nvim), [Tokyo Night](https://github.com/folke/tokyonight.nvim), [Gruvbox](https://github.com/ellisonleao/gruvbox.nvim), [Kanagawa](https://github.com/rebelot/kanagawa.nvim), [Nord](https://github.com/shaunsingh/nord.nvim), [One Dark Pro](https://github.com/olimorris/onedarkpro.nvim), [Dracula](https://github.com/Mofiqul/dracula.nvim), [Rose Pine](https://github.com/rose-pine/neovim), [Nightfox](https://github.com/EdenEast/nightfox.nvim), [Everforest](https://github.com/neanias/everforest-nvim)

And many more excellent plugins!

## 📊 Stats

- **Lines of Code**: ~3,500+ (modular & maintainable)
- **Plugins**: 60+ (50+ features + 10 themes)
- **Supported Languages**: 15+
- **Platforms**: 3 (macOS, Linux, WSL)
- **Profiles**: 7 pre-configured (+ unlimited custom)
- **Themes**: 10+ with 25+ variants
- **Icon Sets**: 3 (VSCode, Nerd, Minimal)
- **Components**: 9 modular toggleable features
- **Custom Commands**: 25+
- **Files**: 35+ well-organized modules
- **Documentation**: 8 comprehensive guides

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/quadbyte/nvim-ultimate/issues)
- **Discussions**: [GitHub Discussions](https://github.com/quadbyte/nvim-ultimate/discussions)
- **Documentation**: This README + 8 comprehensive guides + inline code comments

> **Repository**: https://github.com/quadbyte/nvim-ultimate

---

**Made with ❤️ by QuadByte for developers working across multiple companies and tech stacks**

⚡ Fast • 🎯 Focused • 🌍 Universal

**© 2024-2025 QuadByte** | [GitHub](https://github.com/quadbyte/nvim-ultimate)
