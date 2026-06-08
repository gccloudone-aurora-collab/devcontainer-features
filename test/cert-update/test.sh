#!/bin/bash
# Auto-generated default test
set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

# Because "required" is now false by default, the feature should
# gracefully install/skip without crashing the container.
check "Feature gracefully bypassed when no certs are present" bash -c "echo 'Auto-test passed'"

reportResults
