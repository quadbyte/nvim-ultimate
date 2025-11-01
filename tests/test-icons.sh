#!/usr/bin/env bash
# Test all icon sets

set -e

REPORT_FILE="/tmp/nvim-icons-test.log"

echo "════════════════════════════════════════════════════════════" | tee "${REPORT_FILE}"
echo "Testing All Icon Sets" | tee -a "${REPORT_FILE}"
echo "════════════════════════════════════════════════════════════" | tee -a "${REPORT_FILE}"
echo "" | tee -a "${REPORT_FILE}"

ICON_SETS=("vscode" "nerd" "minimal")
PASSED=0
FAILED=0

for ICON_SET in "${ICON_SETS[@]}"; do
    echo "Testing icon set: ${ICON_SET}" | tee -a "${REPORT_FILE}"

    # Create test Lua script
    TEST_SCRIPT=$(cat <<EOF
-- Test icon loading
local ok, icon_manager = pcall(require, "icons")
if not ok then
  print("ERROR: Icon manager not loaded")
  vim.cmd("cq")
end

-- Switch to icon set
local success = pcall(function()
  icon_manager.switch("${ICON_SET}")
end)

if not success then
  print("❌ Icon switch failed: ${ICON_SET}")
  vim.cmd("cq")
end

-- Get icons
local icons = icon_manager.get()

-- Validate icons exist
if icons and icons.ui and icons.diagnostics and icons.git then
  print("✅ Icon set loaded: ${ICON_SET}")
  print("   UI icons: " .. (icons.ui.file or "MISSING"))
  print("   Diagnostic icons: " .. (icons.diagnostics.error or "MISSING"))
  print("   Git icons: " .. (icons.git.added or "MISSING"))
  vim.cmd("qa")
else
  print("❌ Icon set incomplete: ${ICON_SET}")
  vim.cmd("cq")
end
EOF
)

    # Test icon loading
    if echo "${TEST_SCRIPT}" | timeout 15s nvim --headless -c "luafile /dev/stdin" 2>&1 | tee -a "${REPORT_FILE}" | grep -q "✅"; then
        echo "  ✅ PASS" | tee -a "${REPORT_FILE}"
        ((PASSED++))
    else
        echo "  ❌ FAIL" | tee -a "${REPORT_FILE}"
        ((FAILED++))
    fi

    echo "" | tee -a "${REPORT_FILE}"
done

# Summary
echo "════════════════════════════════════════════════════════════" | tee -a "${REPORT_FILE}"
echo "Icon Test Summary:" | tee -a "${REPORT_FILE}"
echo "  Total: $((PASSED + FAILED))" | tee -a "${REPORT_FILE}"
echo "  Passed: ${PASSED}" | tee -a "${REPORT_FILE}"
echo "  Failed: ${FAILED}" | tee -a "${REPORT_FILE}"
echo "════════════════════════════════════════════════════════════" | tee -a "${REPORT_FILE}"

if [ "${FAILED}" -eq 0 ]; then
    echo "✅ ALL ICON SETS PASSED" | tee -a "${REPORT_FILE}"
    exit 0
else
    echo "❌ SOME ICON SETS FAILED" | tee -a "${REPORT_FILE}"
    exit 1
fi
