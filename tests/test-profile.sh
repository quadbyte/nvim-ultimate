#!/bin/bash
# Test a specific profile

set -e

PROFILE="${1:-fullstack}"
REPORT_FILE="/tmp/nvim-profile-${PROFILE}-test.log"

echo "════════════════════════════════════════════════════════════"
echo "Testing Profile: ${PROFILE}"
echo "════════════════════════════════════════════════════════════"
echo ""

# Copy config to writable location if needed
if [ ! -w ~/.config/nvim/profile.json ]; then
    echo "Setting up writable config copy..."
    mkdir -p /tmp/nvim-config
    cp -r ~/.config/nvim/* /tmp/nvim-config/ 2>/dev/null || true
    export XDG_CONFIG_HOME=/tmp
    mkdir -p ${XDG_CONFIG_HOME}/nvim
    cp -r ~/.config/nvim/* ${XDG_CONFIG_HOME}/nvim/ 2>/dev/null || true
fi

# Update profile.json
echo "Setting active profile to: ${PROFILE}"
cat > ${XDG_CONFIG_HOME:-~/.config}/nvim/profile.json << EOF
{
  "active_profile": "${PROFILE}",
  "performance_mode": "balanced"
}
EOF

# Test 1: Basic startup
echo "Test 1: Basic startup test..."
if timeout 30s nvim --headless "+qa" 2>&1 | tee -a "${REPORT_FILE}"; then
    echo "✅ Startup successful"
else
    echo "❌ Startup failed"
    exit 1
fi

# Test 2: Plugin loading
echo ""
echo "Test 2: Plugin loading test..."
if timeout 30s nvim --headless "+Lazy! sync" "+qa" 2>&1 | tee -a "${REPORT_FILE}"; then
    echo "✅ Plugins loaded successfully"
else
    echo "❌ Plugin loading failed"
    exit 1
fi

# Test 3: Health check
echo ""
echo "Test 3: Health check..."
if timeout 30s nvim --headless "+checkhealth" "+qa" 2>&1 | tee -a "${REPORT_FILE}"; then
    echo "✅ Health check completed"
else
    echo "⚠️  Health check had warnings (non-fatal)"
fi

# Test 4: Startup time
echo ""
echo "Test 4: Startup time measurement..."
STARTUP_LOG="/tmp/nvim-startup-${PROFILE}.log"
nvim --startuptime "${STARTUP_LOG}" --headless "+qa" 2>&1

STARTUP_TIME=$(grep -E "^[0-9]+ start" "${STARTUP_LOG}" | tail -1 | awk '{print $1}')
if [ -n "${STARTUP_TIME}" ]; then
    echo "⏱️  Startup time: ${STARTUP_TIME}ms"

    # Check if under performance target
    if [ "${STARTUP_TIME}" -lt 100 ]; then
        echo "✅ Under 100ms target (EXCELLENT)"
    elif [ "${STARTUP_TIME}" -lt 200 ]; then
        echo "✅ Under 200ms (GOOD)"
    else
        echo "⚠️  Over 200ms (needs optimization)"
    fi
else
    echo "⚠️  Could not measure startup time"
fi

# Test 5: Profile-specific commands
echo ""
echo "Test 5: Profile commands..."
if timeout 10s nvim --headless "+ProfileInfo" "+qa" 2>&1 | tee -a "${REPORT_FILE}" | grep -q "${PROFILE}"; then
    echo "✅ ProfileInfo command working"
else
    echo "❌ ProfileInfo command failed"
fi

# Test 6: LSP availability
echo ""
echo "Test 6: LSP server availability..."
if timeout 10s nvim --headless "+LspInfo" "+qa" 2>&1 | tee -a "${REPORT_FILE}"; then
    echo "✅ LSP info accessible"
else
    echo "⚠️  LSP info check had warnings"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Profile Test Complete: ${PROFILE}"
echo "Report saved to: ${REPORT_FILE}"
echo "════════════════════════════════════════════════════════════"
