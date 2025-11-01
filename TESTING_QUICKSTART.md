# Testing Quick Start

> **TL;DR**: Get Neovim Ultimate Edition tested in 5 minutes

## Prerequisites

```bash
docker --version        # Ensure Docker is installed
docker compose version  # Ensure Docker Compose is installed
```

## Quick Test (5 minutes)

### Step 1: Build
```bash
cd /Users/sulthonzh/.szh/config/nvim-ultimate
docker compose build
```

Expected: Build completes successfully (~3-5 minutes)

### Step 2: Run All Tests
```bash
docker compose run --rm nvim-ultimate-test /home/nvim/tests/run-all-tests.sh
```

Expected output:
```
════════════════════════════════════════════════════════════
Neovim Ultimate Edition - Comprehensive Test Suite
════════════════════════════════════════════════════════════

▶ Running: Profile: minimal
  ✅ PASSED

▶ Running: All Themes
  ✅ PASSED

▶ Running: All Icon Sets
  ✅ PASSED

▶ Running: All Components
  ✅ PASSED

▶ Running: Performance Benchmark
  ✅ PASSED

════════════════════════════════════════════════════════════
TEST SUITE SUMMARY
════════════════════════════════════════════════════════════
  Total Tests:  9
  Passed:       9
  Failed:       0

✅ ALL TESTS PASSED!
```

### Step 3: Check Performance
```bash
docker compose up nvim-benchmark
```

Expected output:
```
Profile,Startup Time (ms),Memory (MB),Status
minimal,<30,~50,✅ EXCELLENT (<100ms)
frontend,<50,~120,✅ EXCELLENT (<100ms)
fullstack,<80,~200,✅ GOOD (<200ms)
```

## Individual Tests

### Test Themes
```bash
docker compose up nvim-theme-test
```

Expected: All 20+ theme variants pass

### Test Icons
```bash
docker compose run --rm nvim-ultimate-test /home/nvim/tests/test-icons.sh
```

Expected: All 3 icon sets pass

### Test Components
```bash
docker compose run --rm nvim-ultimate-test /home/nvim/tests/test-components.sh
```

Expected: All 9 components pass

## Interactive Testing

```bash
# Start interactive container
docker compose up -d nvim-interactive
docker compose exec nvim-interactive bash

# Inside container
nvim

# Try these commands:
:ThemePreview           # Browse themes
:IconsSet vscode        # Switch icons
:ProfileSwitch frontend # Switch profiles
:ComponentList          # List components
```

## View Test Reports

```bash
# After running tests, view reports:
docker compose exec nvim-ultimate-test cat /tmp/nvim-ultimate-test-results.log
docker compose exec nvim-benchmark cat /tmp/nvim-benchmark.log
docker compose exec nvim-theme-test cat /tmp/nvim-themes-test.log
```

## Troubleshooting

### Build Fails
```bash
# Clean and rebuild
docker compose down -v
docker compose build --no-cache
```

### Tests Timeout
```bash
# Increase timeout in test scripts (tests/*.sh)
# Change: timeout 30s
# To: timeout 60s
```

### Can't Access Container
```bash
# Check if running
docker compose ps

# View logs
docker compose logs nvim-ultimate-test

# Restart
docker compose restart nvim-ultimate-test
```

## Clean Up

```bash
# Stop all containers
docker compose down

# Remove volumes (fresh start)
docker compose down -v

# Full cleanup
docker compose down -v --rmi all
```

## Expected Results

**✅ All tests should pass with:**
- Startup time <100ms (fullstack profile)
- All themes loading correctly
- All icon sets working
- All components functional
- No errors in health check

**If any test fails:**
1. Check test logs in `/tmp/`
2. Review error messages
3. See [DOCKER_TESTING.md](DOCKER_TESTING.md) for detailed troubleshooting

## Next Steps

After all tests pass:
1. ✅ Mark as production-ready
2. ✅ Deploy to production
3. ✅ Set up CI/CD (see [DOCKER_TESTING.md](DOCKER_TESTING.md))

---

**Full Documentation**: [TEST_REPORT.md](TEST_REPORT.md)
**Docker Guide**: [DOCKER_TESTING.md](DOCKER_TESTING.md)
