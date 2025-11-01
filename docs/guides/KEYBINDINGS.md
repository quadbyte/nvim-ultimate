# Keybindings Reference

Complete keybinding reference for Neovim Ultimate Edition.

> **Leader key**: `<Space>`

## Table of Contents
- [Core Operations](#core-operations)
- [File Navigation](#file-navigation)
- [Buffer Management](#buffer-management)
- [Window Management](#window-management)
- [LSP & Code](#lsp--code)
- [Git](#git)
- [Search & Replace](#search--replace)
- [Terminal](#terminal)
- [Sessions](#sessions)
- [UI & Toggles](#ui--toggles)
- [Plugins](#plugins)

---

## Core Operations

| Key | Mode | Action |
|-----|------|--------|
| `<Space>w` | n | Save file |
| `<Space>W` | n | Save all files |
| `<Space>q` | n | Quit |
| `<Space>Q` | n | Quit all (force) |
| `<Space>x` | n | Save and quit |
| `<Esc>` | n | Clear search highlight |
| `<C-a>` | n | Select all |

## File Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<Space>e` | n | Toggle file explorer (Neo-tree) |
| `<Space>E` | n | Reveal current file in explorer |
| `<Space>ff` | n | Find files (Telescope) |
| `<Space>fg` | n | Live grep (search in files) |
| `<Space>fb` | n | Find buffers |
| `<Space>fr` | n | Recent files |
| `<Space>fh` | n | Help tags |
| `<Space>fc` | n | Commands (Telescope) |
| `<Space>fn` | n | New file |

## Buffer Management

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | n | Next buffer |
| `<S-Tab>` | n | Previous buffer |
| `<Space>bn` | n | Next buffer |
| `<Space>bp` | n | Previous buffer |
| `<Space>bd` | n | Delete buffer |
| `<Space>bD` | n | Delete buffer (force) |
| `<Space>ba` | n | Delete all buffers except current |
| `<Space>bp` | n | Toggle buffer pin (BufferLine) |
| `<Space>bP` | n | Delete non-pinned buffers |

## Window Management

| Key | Mode | Action |
|-----|------|--------|
| `<C-h>` | n | Go to left window |
| `<C-j>` | n | Go to lower window |
| `<C-k>` | n | Go to upper window |
| `<C-l>` | n | Go to right window |
| `<Space>sv` | n | Vertical split |
| `<Space>sh` | n | Horizontal split |
| `<Space>sx` | n | Close split |
| `<Space>s=` | n | Equal splits |
| `<C-Up>` | n | Increase height |
| `<C-Down>` | n | Decrease height |
| `<C-Left>` | n | Decrease width |
| `<C-Right>` | n | Increase width |

## LSP & Code

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Go to definition |
| `gr` | n | Show references |
| `gI` | n | Go to implementation |
| `gD` | n | Go to declaration |
| `K` | n | Hover documentation |
| `<Space>lr` | n | Rename symbol |
| `<Space>la` | n | Code actions |
| `<Space>lf` | n,v | Format code |
| `<Space>D` | n | Type definition |
| `<Space>ds` | n | Document symbols |
| `<Space>ws` | n | Workspace symbols |
| `[d` | n | Previous diagnostic |
| `]d` | n | Next diagnostic |
| `[e` | n | Previous error |
| `]e` | n | Next error |
| `<Space>cs` | n | Code structure (Aerial) |
| `<Space>cS` | n | Code structure open |
| `]]` | n | Next reference (illuminate) |
| `[[` | n | Prev reference (illuminate) |

## Git

| Key | Mode | Action |
|-----|------|--------|
| `<Space>gg` | n | LazyGit |
| `<Space>gp` | n | Preview hunk |
| `<Space>gr` | n | Reset hunk |
| `<Space>gR` | n | Reset buffer |
| `<Space>gs` | n | Stage hunk |
| `<Space>gS` | n | Stage buffer |
| `<Space>gu` | n | Undo stage hunk |
| `<Space>gb` | n | Blame line |
| `<Space>gd` | n | Diff this |
| `<Space>gD` | n | Diff this ~ |
| `[h` | n | Previous hunk |
| `]h` | n | Next hunk |

## Search & Replace

| Key | Mode | Action |
|-----|------|--------|
| `<Space>sr` | n | Replace in files (Spectre) |
| `<Space>sw` | n | Search current word |
| `<Space>sw` | v | Search selection |
| `<Space>sp` | n | Search in current file |
| `gw` | n,x | Search word under cursor |
| `s` | n,x,o | Flash jump |
| `S` | n,x,o | Flash treesitter |
| `r` | o | Remote flash |

## Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<C-\>` | n | Toggle terminal |
| `<Space>tf` | n | Float terminal |
| `<Space>th` | n | Horizontal terminal |
| `<Space>tv` | n | Vertical terminal |
| `<Esc><Esc>` | t | Exit terminal mode |
| `<C-h>` | t | Go to left window |
| `<C-j>` | t | Go to lower window |
| `<C-k>` | t | Go to upper window |
| `<C-l>` | t | Go to right window |

## Sessions

| Key | Mode | Action |
|-----|------|--------|
| `<Space>qs` | n | Restore session |
| `<Space>ql` | n | Restore last session |
| `<Space>qd` | n | Don't save current session |

## UI & Toggles

| Key | Mode | Action |
|-----|------|--------|
| `<Space>uw` | n | Toggle wrap |
| `<Space>us` | n | Toggle spell |
| `<Space>un` | n | Toggle relative number |
| `<Space>un` | n | Dismiss all notifications |
| `<Space>xx` | n | Document diagnostics (Trouble) |
| `<Space>xX` | n | Workspace diagnostics (Trouble) |
| `<Space>xL` | n | Location list (Trouble) |
| `<Space>xQ` | n | Quickfix list (Trouble) |
| `<Space>xt` | n | Todo (Trouble) |
| `<Space>xT` | n | Todo (Telescope) |

## Folding (UFO)

| Key | Mode | Action |
|-----|------|--------|
| `zR` | n | Open all folds |
| `zM` | n | Close all folds |
| `zr` | n | Open folds except kinds |
| `zm` | n | Close folds with |
| `zK` | n | Peek fold |

## Plugins

### Noice.nvim
| Key | Mode | Action |
|-----|------|--------|
| `<Space>snl` | n | Noice last message |
| `<Space>snh` | n | Noice history |
| `<Space>sna` | n | Noice all |
| `<Space>snd` | n | Dismiss all |
| `<C-f>` | i,n,s | Scroll forward in hover |
| `<C-b>` | i,n,s | Scroll backward in hover |

### Harpoon
| Key | Mode | Action |
|-----|------|--------|
| `<Space>ha` | n | Add to harpoon |
| `<Space>hh` | n | Harpoon menu |
| `<Space>1` | n | Harpoon file 1 |
| `<Space>2` | n | Harpoon file 2 |
| `<Space>3` | n | Harpoon file 3 |
| `<Space>4` | n | Harpoon file 4 |

### Comments
| Key | Mode | Action |
|-----|------|--------|
| `gcc` | n | Comment toggle line |
| `gc` | n,o | Comment toggle linewise |
| `gc` | x | Comment toggle linewise (visual) |
| `gbc` | n | Comment toggle block |
| `gb` | n,o | Comment toggle blockwise |
| `gb` | x | Comment toggle blockwise (visual) |

### Markdown Preview
| Key | Mode | Action |
|-----|------|--------|
| `<Space>mp` | n | Markdown preview toggle |

### Todo Comments
| Key | Mode | Action |
|-----|------|--------|
| `]t` | n | Next todo comment |
| `[t` | n | Previous todo comment |

## Editing

| Key | Mode | Action |
|-----|------|--------|
| `j` | n,x | Better j (handles wrapped lines) |
| `k` | n,x | Better k (handles wrapped lines) |
| `<` | v | Indent left (stays in visual) |
| `>` | v | Indent right (stays in visual) |
| `p` | x | Paste without yanking |
| `<Space>d` | n,v | Delete without yank |
| `<A-j>` | n | Move line down |
| `<A-k>` | n | Move line up |
| `<A-j>` | v | Move selection down |
| `<A-k>` | v | Move selection up |
| `+` | n | Increment number |
| `-` | n | Decrement number |
| `'` | n | Go to mark (exact position) |
| `` ` `` | n | Go to mark (line) |

## Command Line

| Key | Mode | Action |
|-----|------|--------|
| `<C-a>` | c | Go to beginning |
| `<C-e>` | c | Go to end |
| `<C-p>` | c | Previous command |
| `<C-n>` | c | Next command |

## Quick Fix & Location List

| Key | Mode | Action |
|-----|------|--------|
| `[q` | n | Previous quickfix |
| `]q` | n | Next quickfix |
| `[l` | n | Previous location |
| `]l` | n | Next location |

---

## Custom Commands

Type these in command mode (`:`):

### Profile Management
- `:ProfileSwitch <name>` - Switch to a different profile
- `:ProfileInfo` - Show current profile information
- `:ProfileList` - List all available profiles
- `:ProfilePicker` - Telescope picker for profiles
- `:ProfileBench` - Benchmark all profiles
- `:ProfileClone <src> <dst>` - Clone and customize a profile
- `:ProfileValidate` - Validate current profile
- `:ProfileCreateLocal` - Create project-local profile

### Health & Diagnostics
- `:NvimUltimateHealth` - Run comprehensive health check
- `:checkhealth` - Built-in Neovim health check
- `:StartupTime` - Show startup time breakdown

### Utility
- `:EditConfig` - Quick edit init.lua
- `:EditProfiles` - Edit profile configuration
- `:EditKeymaps` - Edit keymaps
- `:CopyPath [full|relative|name]` - Copy file path
- `:ClearCache` - Clear all cache files
- `:UpdatePlugins` - Update all plugins
- `:FormatToggle` - Toggle auto-format on save

### Plugin Commands
- `:Lazy` - Plugin manager UI
- `:Mason` - LSP server manager
- `:Telescope` - Fuzzy finder
- `:AerialToggle` - Code outline
- `:MarkdownPreview` - Markdown preview
- `:LazyGit` - Git UI

---

## Tips

1. **Which-key**: Press `<Space>` and wait to see all available bindings
2. **Telescope**: Use `<C-j>` and `<C-k>` to navigate in Telescope
3. **LSP**: Most LSP commands are under `<Space>l` prefix
4. **Git**: Most Git commands are under `<Space>g` prefix
5. **File operations**: Use `<Space>f` prefix
6. **Buffer operations**: Use `<Space>b` prefix
7. **Quick help**: Type `:Telescope keymaps` to search all keybindings

---

**Happy coding!** 🚀
