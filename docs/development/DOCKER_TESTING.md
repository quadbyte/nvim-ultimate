# Docker Testing Guide

Complete guide for testing Neovim Ultimate Edition using Docker.

## Quick Start

### Build and Run Tests

```bash
# Build the Docker image
docker compose build

# Run all tests
docker compose up nvim-ultimate-test

# Run specific test service
docker compose up nvim-minimal        # Test minimal profile
docker compose up nvim-frontend       # Test frontend profile
docker compose up nvim-backend        # Test backend profile
docker compose up nvim-theme-test     # Test all themes
docker compose up nvim-benchmark      # Run performance benchmark

# Interactive mode
docker compose up nvim-interactive
docker compose exec nvim-interactive bash
```

### Inside Interactive Container

```bash
# Launch Neovim
nvim

# Run individual tests
/home/nvim/tests/test-profile.sh fullstack
/home/nvim/tests/test-themes.sh
/home/nvim/tests/test-icons.sh
/home/nvim/tests/test-components.sh
/home/nvim/tests/benchmark.sh

# Run all tests
/home/nvim/tests/run-all-tests.sh
```

## Docker Services

### nvim-ultimate-test
Main testing environment with all tools installed.

**Usage:**
```bash
docker compose up nvim-ultimate-test
docker compose exec nvim-ultimate-test bash
```

### nvim-minimal
Tests the minimal profile specifically.

**Usage:**
```bash
docker compose up nvim-minimal
```

### nvim-frontend / nvim-backend
Tests specific development profiles.

**Usage:**
```bash
docker compose up nvim-frontend
docker compose up nvim-backend
```

### nvim-theme-test
Tests all 10+ colorschemes with 25+ variants.

**Usage:**
```bash
docker compose up nvim-theme-test
```

**Expected output:**
```
Testing: catppuccin mocha
  ✅ PASS
Testing: tokyonight night
  ✅ PASS
...
✅ ALL THEMES PASSED
```

### nvim-benchmark
Runs performance benchmarks on all profiles.

**Usage:**
```bash
docker compose up nvim-benchmark
```

**Expected output:**
```
Profile,Startup Time (ms),Memory (MB),Status
minimal,<30ms,~50,✅ EXCELLENT
frontend,<50ms,~120,✅ EXCELLENT
fullstack,<80ms,~200,✅ GOOD
```

### nvim-interactive
Interactive environment for manual testing.

**Usage:**
```bash
docker compose up -d nvim-interactive
docker compose exec nvim-interactive bash

# Inside container
nvim testfile.lua
:ThemePreview
:ProfileSwitch frontend
:IconsSet vscode
```

## Test Scripts

### test-profile.sh
Tests a specific profile.

```bash
/home/nvim/tests/test-profile.sh <profile>
```

**Tests performed:**
1. Basic startup
2. Plugin loading
3. Health check
4. Startup time measurement
5. Profile commands
6. LSP availability

### test-themes.sh
Tests all themes and variants.

```bash
/home/nvim/tests/test-themes.sh
```

**Themes tested:**
- Catppuccin (4 variants)
- Tokyo Night (4 variants)
- Gruvbox, Kanagawa, Nord, One Dark Pro, Dracula, Rose Pine (3 variants), Nightfox (7 variants), Everforest

### test-icons.sh
Tests all icon sets.

```bash
/home/nvim/tests/test-icons.sh
```

**Icon sets tested:**
- VSCode Codicons
- Nerd Fonts
- Minimal ASCII

### test-components.sh
Tests all modular components.

```bash
/home/nvim/tests/test-components.sh
```

**Components tested:**
- Statusline, Tabline, Explorer, Terminal
- Git Signs, Completion, Diagnostics
- Notifications, Outline

### benchmark.sh
Performance benchmark for all profiles.

```bash
/home/nvim/tests/benchmark.sh
```

**Metrics measured:**
- Startup time (average of 3 runs)
- Memory usage estimate
- Performance status

### run-all-tests.sh
Master test runner (all tests).

```bash
/home/nvim/tests/run-all-tests.sh
```

**Runs:**
- Profile tests (minimal, frontend, backend, fullstack)
- Theme tests (all themes)
- Icon tests (all icon sets)
- Component tests (all components)
- Performance benchmark

## Continuous Integration

### GitHub Actions Example

```yaml
name: Test Neovim Ultimate

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Build Docker image
        run: docker compose build nvim-ultimate-test

      - name: Run tests
        run: docker compose up --abort-on-container-exit nvim-ultimate-test

      - name: Run benchmark
        run: docker compose up --abort-on-container-exit nvim-benchmark

      - name: Upload test reports
        uses: actions/upload-artifact@v3
        with:
          name: test-reports
          path: /tmp/nvim-*.log
```

## Debugging

### View logs

```bash
# All services
docker compose logs

# Specific service
docker compose logs nvim-theme-test

# Follow logs
docker compose logs -f nvim-ultimate-test
```

### Access test reports

```bash
# Inside container
cat /tmp/nvim-profile-fullstack-test.log
cat /tmp/nvim-themes-test.log
cat /tmp/nvim-icons-test.log
cat /tmp/nvim-components-test.log
cat /tmp/nvim-benchmark.log
cat /tmp/nvim-ultimate-test-results.log

# Copy from container
docker compose cp nvim-ultimate-test:/tmp/nvim-ultimate-test-results.log ./
```

### Shell into container

```bash
docker compose exec nvim-ultimate-test bash

# Or start a new container
docker compose run --rm nvim-ultimate-test bash
```

### Clean up

```bash
# Stop all containers
docker compose down

# Remove volumes (fresh start)
docker compose down -v

# Remove images
docker compose down --rmi all

# Full cleanup
docker compose down -v --rmi all
```

## Troubleshooting

### Plugin installation fails

```bash
# Inside container
nvim --headless "+Lazy! sync" +qa

# Check Lazy status
nvim --headless "+Lazy status" +qa
```

### Theme not loading

```bash
# Check available themes
nvim --headless "+ThemeList" +qa

# Try loading theme manually
nvim --headless "+ThemeSwitch catppuccin mocha" +qa
```

### LSP not working

```bash
# Check Mason installations
nvim --headless "+Mason" +qa

# Check LSP status
nvim --headless "+LspInfo" +qa
```

### Startup too slow

```bash
# Check startup time breakdown
nvim --startuptime /tmp/startup.log --headless +qa
cat /tmp/startup.log
```

## Performance Targets

| Profile | Startup Time | Memory | Status |
|---------|-------------|--------|---------|
| Minimal | <50ms | <80MB | ✅ Target |
| Frontend | <60ms | <150MB | ✅ Target |
| Backend | <60ms | <150MB | ✅ Target |
| Mobile | <60ms | <150MB | ✅ Target |
| Data | <60ms | <150MB | ✅ Target |
| DevOps | <60ms | <150MB | ✅ Target |
| Fullstack | <100ms | <250MB | ✅ Target |

## Best Practices

### 1. Test Before Committing
```bash
docker compose up nvim-ultimate-test
```

### 2. Benchmark Changes
```bash
# Before changes
docker compose up nvim-benchmark > before.log

# After changes
docker compose up nvim-benchmark > after.log

# Compare
diff before.log after.log
```

### 3. Test All Profiles
```bash
for profile in minimal frontend backend fullstack; do
  docker compose run --rm nvim-ultimate-test /home/nvim/tests/test-profile.sh $profile
done
```

### 4. Verify Themes
```bash
docker compose up nvim-theme-test
```

### 5. Component Tests
```bash
docker compose run --rm nvim-ultimate-test /home/nvim/tests/test-components.sh
```

## Advanced Usage

### Custom Test

Create custom test script in `tests/`:

```bash
#!/bin/bash
# tests/my-custom-test.sh

echo "Running custom test..."

nvim --headless "+MyCustomCommand" +qa

echo "✅ Custom test passed"
```

### Mount Local Files

```yaml
# docker-compose.override.yml
version: '3.8'

services:
  nvim-interactive:
    volumes:
      - ~/projects:/home/nvim/projects:rw
```

### Environment Variables

```bash
# Set custom environment
NVIM_PROFILE=backend docker compose up nvim-ultimate-test
TERM=xterm-256color docker compose up nvim-benchmark
```

---

**Happy Testing!** 🐳
