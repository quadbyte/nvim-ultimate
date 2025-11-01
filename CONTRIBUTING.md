# Contributing to Neovim Ultimate Edition

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help maintain a welcoming environment

## How to Contribute

### Reporting Issues

1. Check if the issue already exists
2. Use the issue template (if available)
3. Include:
   - Your OS and Neovim version (`:version`)
   - Active profile (`:ProfileInfo`)
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant logs

### Suggesting Features

1. Open an issue with the `feature` label
2. Describe the use case clearly
3. Explain how it aligns with the project goals:
   - Multi-platform support
   - Profile-based configuration
   - Performance optimization
   - Professional developer workflows

### Submitting Pull Requests

#### Setup

```bash
# Fork and clone the repository
git clone https://github.com/quadbyte/nvim-ultimate.git
cd nvim-ultimate

# Create a feature branch
git checkout -b feature/your-feature-name
```

#### Guidelines

1. **Code Style**
   - Follow existing code patterns
   - Use 2 spaces for indentation (Lua files)
   - Add comments for complex logic
   - Use descriptive variable names

2. **Structure**
   - Keep files modular and focused
   - Place plugins in appropriate categories (ui, editor, lsp, etc.)
   - Maintain profile-based loading where applicable

3. **Performance**
   - Use lazy loading for plugins
   - Avoid blocking operations
   - Test startup time impact
   - Keep minimal profile lightweight

4. **Documentation**
   - Update README.md if adding features
   - Add comments in code
   - Update CHANGELOG.md
   - Include keybinding documentation

5. **Testing**
   - Test on multiple platforms (if possible)
   - Test with different profiles
   - Verify no breaking changes
   - Check startup time: `nvim --startuptime startup.log`

#### Pull Request Process

1. Update documentation
2. Update CHANGELOG.md
3. Ensure code follows style guidelines
4. Test thoroughly
5. Create PR with clear description
6. Reference related issues

### Adding a New Plugin

```lua
-- Template for new plugin
return {
  "author/plugin-name",
  event = "VeryLazy",  -- or appropriate event
  dependencies = {},
  keys = {
    { "<leader>key", "<cmd>Command<cr>", desc = "Description" },
  },
  opts = {
    -- configuration
  },
}
```

### Adding a New Profile

```lua
-- In lua/utils/profile.lua
M.profiles.yourprofile = {
  name = "Your Profile Name",
  description = "Description of the profile",
  languages = { "lang1", "lang2" },
  lsp_servers = { "server1", "server2" },
  formatters = { "formatter1" },
  linters = { "linter1" },
}
```

## Development Workflow

### Local Testing

```bash
# Test your changes
NVIM_APPNAME=nvim-ultimate-test nvim

# Check startup time
nvim --startuptime startup.log +qa && tail -n 1 startup.log

# Test with different profiles
# Edit profile.json and restart
```

### Useful Commands

```vim
:Lazy sync          " Sync plugins
:checkhealth        " Check Neovim health
:ProfileInfo        " Show active profile
:ProfileBench       " Benchmark startup time
:messages           " View messages
```

## Project Structure

```
nvim-ultimate/
├── init.lua              # Entry point
├── lua/
│   ├── core/            # Core configuration
│   │   ├── options.lua  # Editor settings
│   │   ├── keymaps.lua  # Keybindings
│   │   ├── autocmds.lua # Autocommands
│   │   └── lazy.lua     # Plugin manager
│   ├── plugins/         # Plugin configurations
│   │   ├── ui.lua       # UI plugins
│   │   ├── editor.lua   # Editor enhancements
│   │   ├── lsp/         # LSP configuration
│   │   ├── navigation.lua
│   │   ├── git.lua
│   │   └── terminal.lua
│   └── utils/           # Utilities
│       ├── profile.lua  # Profile system
│       ├── platform.lua # Platform detection
│       └── helpers.lua  # Helper functions
├── install.sh           # Installation script
└── profile.json         # Active profile config
```

## Performance Guidelines

### Startup Time Targets

- **Minimal**: <50ms
- **Specific profiles**: <80ms
- **Full Stack**: <120ms

### Best Practices

1. **Lazy Loading**
   ```lua
   event = "VeryLazy"  -- Load after startup
   cmd = "Command"     -- Load on command
   ft = "filetype"     -- Load on filetype
   keys = "<leader>k"  -- Load on keypress
   ```

2. **Conditional Loading**
   ```lua
   cond = function()
     return vim.fn.executable("tool") == 1
   end
   ```

3. **Profile-Based Loading**
   ```lua
   -- Check if language is in active profile
   if require("utils.profile").has_language("python") then
     -- Load Python-specific plugins
   end
   ```

## Questions?

- Open an issue for questions
- Check existing issues and documentation
- Review README.md and QUICKSTART.md

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Neovim Ultimate Edition!** 🚀
