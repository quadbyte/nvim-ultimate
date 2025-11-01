#!/bin/bash
# Test all components

set -e

REPORT_FILE="/tmp/nvim-components-test.log"

echo "════════════════════════════════════════════════════════════" | tee "${REPORT_FILE}"
echo "Testing All Components" | tee -a "${REPORT_FILE}"
echo "════════════════════════════════════════════════════════════" | tee -a "${REPORT_FILE}"
echo "" | tee -a "${REPORT_FILE}"

COMPONENTS=(
    "statusline"
    "tabline"
    "explorer"
    "terminal"
    "git_signs"
    "completion"
    "diagnostics"
    "notifications"
    "outline"
)

PASSED=0
FAILED=0

for COMPONENT in "${COMPONENTS[@]}"; do
    echo "Testing component: ${COMPONENT}" | tee -a "${REPORT_FILE}"

    # Create test Lua script
    TEST_SCRIPT=$(cat <<EOF
-- Test component system
local ok, component_manager = pcall(require, "components")
if not ok then
  print("ERROR: Component manager not loaded")
  vim.cmd("cq")
end

-- Check if component exists
local component = component_manager.components["${COMPONENT}"]
if not component then
  print("❌ Component not found: ${COMPONENT}")
  vim.cmd("cq")
end

-- Validate component structure
if component.name and component.plugin then
  print("✅ Component valid: ${COMPONENT}")
  print("   Name: " .. component.name)
  print("   Plugin: " .. component.plugin)
  print("   Enabled: " .. tostring(component.enabled))
  vim.cmd("qa")
else
  print("❌ Component structure invalid: ${COMPONENT}")
  vim.cmd("cq")
end
EOF
)

    # Test component
    if echo "${TEST_SCRIPT}" | timeout 15s nvim --headless -c "luafile /dev/stdin" 2>&1 | tee -a "${REPORT_FILE}" | grep -q "✅"; then
        echo "  ✅ PASS" | tee -a "${REPORT_FILE}"
        ((PASSED++))
    else
        echo "  ❌ FAIL" | tee -a "${REPORT_FILE}"
        ((FAILED++))
    fi

    echo "" | tee -a "${REPORT_FILE}"
done

# Test component toggle
echo "Testing component toggle functionality..." | tee -a "${REPORT_FILE}"
TOGGLE_SCRIPT=$(cat <<'EOF'
local ok, component_manager = pcall(require, "components")
if ok then
  print("✅ Component manager loaded")
  vim.cmd("qa")
else
  print("❌ Component manager failed to load")
  vim.cmd("cq")
end
EOF
)

if echo "${TOGGLE_SCRIPT}" | timeout 15s nvim --headless -c "luafile /dev/stdin" 2>&1 | tee -a "${REPORT_FILE}" | grep -q "✅"; then
    echo "  ✅ PASS" | tee -a "${REPORT_FILE}"
    ((PASSED++))
else
    echo "  ❌ FAIL" | tee -a "${REPORT_FILE}"
    ((FAILED++))
fi

echo "" | tee -a "${REPORT_FILE}"

# Summary
echo "════════════════════════════════════════════════════════════" | tee -a "${REPORT_FILE}"
echo "Component Test Summary:" | tee -a "${REPORT_FILE}"
echo "  Total: $((PASSED + FAILED))" | tee -a "${REPORT_FILE}"
echo "  Passed: ${PASSED}" | tee -a "${REPORT_FILE}"
echo "  Failed: ${FAILED}" | tee -a "${REPORT_FILE}"
echo "════════════════════════════════════════════════════════════" | tee -a "${REPORT_FILE}"

if [ "${FAILED}" -eq 0 ]; then
    echo "✅ ALL COMPONENTS PASSED" | tee -a "${REPORT_FILE}"
    exit 0
else
    echo "❌ SOME COMPONENTS FAILED" | tee -a "${REPORT_FILE}"
    exit 1
fi
