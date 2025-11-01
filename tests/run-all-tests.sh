#!/usr/bin/env bash
# Master test runner - runs all tests

set -e

MASTER_REPORT="/tmp/nvim-ultimate-test-results.log"
START_TIME=$(date +%s)

echo "════════════════════════════════════════════════════════════" | tee "${MASTER_REPORT}"
echo "Neovim Ultimate Edition - Comprehensive Test Suite" | tee -a "${MASTER_REPORT}"
echo "════════════════════════════════════════════════════════════" | tee -a "${MASTER_REPORT}"
echo "Started: $(date)" | tee -a "${MASTER_REPORT}"
echo "" | tee -a "${MASTER_REPORT}"

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Function to run a test
run_test() {
    local TEST_NAME="$1"
    local TEST_SCRIPT="$2"

    echo "" | tee -a "${MASTER_REPORT}"
    echo "▶ Running: ${TEST_NAME}" | tee -a "${MASTER_REPORT}"
    echo "────────────────────────────────────────────────────────────" | tee -a "${MASTER_REPORT}"

    ((TOTAL_TESTS++))

    if bash "${TEST_SCRIPT}" 2>&1 | tee -a "${MASTER_REPORT}"; then
        echo "✅ PASSED: ${TEST_NAME}" | tee -a "${MASTER_REPORT}"
        ((PASSED_TESTS++))
        return 0
    else
        echo "❌ FAILED: ${TEST_NAME}" | tee -a "${MASTER_REPORT}"
        ((FAILED_TESTS++))
        return 1
    fi
}

# Test 1: Profile Tests
for PROFILE in minimal frontend backend fullstack; do
    run_test "Profile: ${PROFILE}" "$(dirname "$0")/test-profile.sh ${PROFILE}" || true
done

# Test 2: Theme Tests
run_test "All Themes" "$(dirname "$0")/test-themes.sh" || true

# Test 3: Icon Tests
run_test "All Icon Sets" "$(dirname "$0")/test-icons.sh" || true

# Test 4: Component Tests
run_test "All Components" "$(dirname "$0")/test-components.sh" || true

# Test 5: Performance Benchmark
run_test "Performance Benchmark" "$(dirname "$0")/benchmark.sh" || true

# Calculate test duration
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# Final Summary
echo "" | tee -a "${MASTER_REPORT}"
echo "════════════════════════════════════════════════════════════" | tee -a "${MASTER_REPORT}"
echo "TEST SUITE SUMMARY" | tee -a "${MASTER_REPORT}"
echo "════════════════════════════════════════════════════════════" | tee -a "${MASTER_REPORT}"
echo "  Total Tests:  ${TOTAL_TESTS}" | tee -a "${MASTER_REPORT}"
echo "  Passed:       ${PASSED_TESTS}" | tee -a "${MASTER_REPORT}"
echo "  Failed:       ${FAILED_TESTS}" | tee -a "${MASTER_REPORT}"
echo "  Duration:     ${DURATION} seconds" | tee -a "${MASTER_REPORT}"
echo "" | tee -a "${MASTER_REPORT}"

if [ "${FAILED_TESTS}" -eq 0 ]; then
    echo "✅ ALL TESTS PASSED!" | tee -a "${MASTER_REPORT}"
    RESULT=0
else
    PASS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo "⚠️  ${FAILED_TESTS} test(s) failed (${PASS_RATE}% pass rate)" | tee -a "${MASTER_REPORT}"
    RESULT=1
fi

echo "" | tee -a "${MASTER_REPORT}"
echo "Finished: $(date)" | tee -a "${MASTER_REPORT}"
echo "Full report: ${MASTER_REPORT}" | tee -a "${MASTER_REPORT}"
echo "════════════════════════════════════════════════════════════" | tee -a "${MASTER_REPORT}"

exit ${RESULT}
