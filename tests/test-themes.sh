#!/bin/bash
# Test all themes

set -e

REPORT_FILE="/tmp/nvim-themes-test.log"

echo "════════════════════════════════════════════════════════════" | tee "${REPORT_FILE}"
echo "Testing All Themes (10+ colorschemes)" | tee -a "${REPORT_FILE}"
echo "════════════════════════════════════════════════════════════" | tee -a "${REPORT_FILE}"
echo "" | tee -a "${REPORT_FILE}"

# List of themes to test
THEMES=(
    "catppuccin mocha"
    "catppuccin macchiato"
    "catppuccin frappe"
    "catppuccin latte"
    "tokyonight night"
    "tokyonight storm"
    "tokyonight moon"
    "tokyonight day"
    "gruvbox dark"
    "kanagawa wave"
    "nord"
    "onedark"
    "dracula"
    "rosepine main"
    "rosepine moon"
    "rosepine dawn"
    "nightfox"
    "dayfox"
    "nordfox"
    "everforest"
)

PASSED=0
FAILED=0

for theme_info in "${THEMES[@]}"; do
    # Parse theme name and variant
    read -r THEME VARIANT <<< "${theme_info}"

    echo "Testing: ${THEME} ${VARIANT:-default}" | tee -a "${REPORT_FILE}"

    # Create test Lua script
    TEST_SCRIPT=$(cat <<EOF
-- Test theme loading
local ok, theme_manager = pcall(require, "themes")
if not ok then
  print("ERROR: Theme manager not loaded")
  vim.cmd("cq")
end

-- Apply theme
local success = pcall(function()
  theme_manager.apply("${THEME}", "${VARIANT}")
end)

if success then
  print("✅ Theme applied: ${THEME} ${VARIANT:-default}")
  vim.cmd("qa")
else
  print("❌ Theme failed: ${THEME} ${VARIANT:-default}")
  vim.cmd("cq")
end
EOF
)

    # Test theme loading
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
echo "Theme Test Summary:" | tee -a "${REPORT_FILE}"
echo "  Total: $((PASSED + FAILED))" | tee -a "${REPORT_FILE}"
echo "  Passed: ${PASSED}" | tee -a "${REPORT_FILE}"
echo "  Failed: ${FAILED}" | tee -a "${REPORT_FILE}"
echo "════════════════════════════════════════════════════════════" | tee -a "${REPORT_FILE}"

if [ "${FAILED}" -eq 0 ]; then
    echo "✅ ALL THEMES PASSED" | tee -a "${REPORT_FILE}"
    exit 0
else
    echo "❌ SOME THEMES FAILED" | tee -a "${REPORT_FILE}"
    exit 1
fi
