# Support

Need help with Neovim Ultimate Edition? We're here to assist you!

## 📚 Documentation

Before seeking support, please check our comprehensive documentation:

### Getting Started
- **[README.md](README.md)** - Main documentation and feature overview
- **[QUICKSTART.md](QUICKSTART.md)** - Quick start guide for new users
- **[KEYBINDINGS.md](KEYBINDINGS.md)** - Complete keybinding reference

### Customization
- **[CUSTOMIZATION.md](CUSTOMIZATION.md)** - Complete customization guide
- **[THEMES.md](THEMES.md)** - Theme system and customization
- **[ICONS.md](ICONS.md)** - Icon system configuration

### Development
- **[DOCKER_TESTING.md](DOCKER_TESTING.md)** - Testing with Docker
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines

## 🔍 Self-Help Resources

### 1. Health Check
Run Neovim's built-in health check:
```vim
:checkhealth
:NvimUltimateHealth
```

### 2. Common Issues

#### Installation Issues
- Ensure Neovim 0.10+ is installed: `nvim --version`
- Check all dependencies: `make check-deps`
- Review installation logs in `/tmp/nvim-ultimate-install-*.log`

#### Plugin Issues
- Update plugins: `make update` or `:Lazy sync`
- Clear plugin cache: `make clean`
- Check plugin status: `:Lazy`

#### LSP Issues
- Check LSP status: `:LspInfo`
- Install missing LSP servers: `:Mason`
- Restart LSP: `:LspRestart`

#### Performance Issues
- Check startup time: `nvim --startuptime startup.log`
- Run benchmarks: `make benchmark`
- Switch to minimal profile: `:ProfileSwitch minimal`

## 💬 Get Help

### GitHub Discussions (Recommended)
For general questions, tips, and community support:
- **[Ask a Question](https://github.com/quadbyte/nvim-ultimate/discussions/new?category=q-a)**
- **[Show and Tell](https://github.com/quadbyte/nvim-ultimate/discussions/new?category=show-and-tell)** - Share your config
- **[Ideas](https://github.com/quadbyte/nvim-ultimate/discussions/new?category=ideas)** - Suggest improvements

### GitHub Issues
For bugs and specific problems:
- **[Report a Bug](https://github.com/quadbyte/nvim-ultimate/issues/new?template=bug_report.yml)**
- **[Request a Feature](https://github.com/quadbyte/nvim-ultimate/issues/new?template=feature_request.yml)**
- **[Ask a Question](https://github.com/quadbyte/nvim-ultimate/issues/new?template=question.yml)**

### Before Creating an Issue

1. **Search existing issues**: Your question might already be answered
2. **Check documentation**: Review relevant guides first
3. **Run health checks**: Use `:checkhealth` and `:NvimUltimateHealth`
4. **Gather information**: Include Neovim version, OS, profile, error messages

### What to Include in Your Issue

When reporting an issue, please include:

```markdown
- **Neovim Version**: (output of `nvim --version`)
- **Operating System**: (macOS / Linux / WSL)
- **Active Profile**: (minimal / frontend / backend / etc.)
- **Steps to Reproduce**: (detailed steps)
- **Expected Behavior**: (what should happen)
- **Actual Behavior**: (what actually happens)
- **Error Messages**: (any error output)
- **Configuration**: (relevant parts of profile.json)
```

## 🚀 Quick Links

- **Repository**: https://github.com/quadbyte/nvim-ultimate
- **Issues**: https://github.com/quadbyte/nvim-ultimate/issues
- **Discussions**: https://github.com/quadbyte/nvim-ultimate/discussions
- **Releases**: https://github.com/quadbyte/nvim-ultimate/releases

## 🔒 Security Issues

If you discover a security vulnerability:
- **DO NOT** open a public issue
- Review our [Security Policy](SECURITY.md)
- Report privately through GitHub Security Advisories

## 📖 Additional Resources

### Neovim Resources
- [Neovim Official Documentation](https://neovim.io/doc/)
- [Neovim GitHub](https://github.com/neovim/neovim)
- [r/neovim Subreddit](https://www.reddit.com/r/neovim/)

### Plugin Documentation
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configs
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder

## 🤝 Contributing

Want to contribute? See our [Contributing Guide](CONTRIBUTING.md)

## 📝 Feedback

We value your feedback! Help us improve:
- Star the repository if you find it useful
- Share your experience in Discussions
- Report bugs and suggest features
- Contribute improvements

---

**Made with ❤️ by QuadByte**

**© 2024-2025 QuadByte** | [GitHub](https://github.com/quadbyte/nvim-ultimate)
