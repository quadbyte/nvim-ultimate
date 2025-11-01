# 🚀 Quick Start Guide

## Installation

```bash
cd ~/.szh/config/nvim-ultimate
./install.sh
```

Follow the interactive prompts to:
1. Choose your profile (frontend, backend, mobile, etc.)
2. Let it install dependencies
3. Launch Neovim!

## Using Profiles

### Switch Profiles

```vim
" In Neovim
:ProfileSwitch backend
:ProfileSwitch frontend
:ProfileInfo              " Show current profile
:ProfileList              " List all profiles
```

### Available Profiles

| Profile | Use Case |
|---------|----------|
| **frontend** | React, Vue, TypeScript, Tailwind |
| **backend** | Python, Go, Rust, Node.js |
| **mobile** | React Native, Flutter, Swift |
| **data** | Python, SQL, R (data science) |
| **devops** | Docker, Kubernetes, Terraform |
| **fullstack** | Everything (slower startup) |
| **minimal** | Super fast, core only |

## Essential Commands

### File Operations
- `<Space>e` - Toggle file explorer
- `<Space>ff` - Find files
- `<Space>fg` - Search in files
- `<Space>w` - Save
- `<Tab>` - Next buffer

### Code Navigation
- `gd` - Go to definition
- `gr` - Show references
- `K` - Documentation
- `<Space>lr` - Rename
- `<Space>la` - Code actions

### Git
- `<Space>gg` - LazyGit
- `]h` / `[h` - Next/previous change

### Terminal
- `<Ctrl-\>` - Toggle terminal
- `<Esc><Esc>` - Exit terminal

## Customization

### Change Profile Manually

Edit `~/.config/nvim/profile.json`:

```json
{
  "active_profile": "backend",
  "performance_mode": "balanced"
}
```

Restart Neovim.

### Disable Auto-Format

```vim
:FormatToggle
```

### Manage Plugins

```vim
:Lazy           " Plugin manager
:Mason          " LSP server manager
:checkhealth    " Check installation
```

## Troubleshooting

### Plugins Not Loading

```vim
:Lazy sync
```

### LSP Not Working

```vim
:Mason
```

Then install missing servers.

### Reset Everything

```bash
# Backup first!
rm -rf ~/.config/nvim ~/.local/share/nvim

# Reinstall
cd ~/.szh/config/nvim-ultimate
./install.sh
```

## Performance

### Check Startup Time

```bash
nvim --startuptime startup.log
cat startup.log
```

### Expected Performance

- **Minimal**: ~20-30ms
- **Frontend/Backend**: ~40-60ms
- **Full Stack**: ~80-120ms

### Optimize

1. Use appropriate profile (don't use fullstack if you only need frontend)
2. Disable unused plugins
3. Use minimal profile for quick edits

## Next Steps

1. ✅ **Learn keybindings**: Press `<Space>` and wait to see all commands
2. ✅ **Customize theme**: Edit `lua/plugins/ui.lua`
3. ✅ **Add languages**: Edit your profile in `lua/utils/profile.lua`
4. ✅ **Configure LSP**: Edit `lua/plugins/lsp/init.lua`
5. ✅ **Share with team**: This config is designed to be shared!

## Daily Workflow

### Morning: Start Work

```bash
# Open project
cd ~/projects/my-app
nvim

# Your profile auto-loads
# LSP servers start automatically
# Start coding!
```

### Switch Context

```vim
" Frontend work
:ProfileSwitch frontend

" Backend work
:ProfileSwitch backend
```

### End of Day

Nvim auto-saves sessions. Just quit:

```vim
:q
```

## Community

- Star the repo if you find it useful!
- Report issues on GitHub
- Share your custom profiles
- Contribute improvements

---

**Happy coding! 🚀**
