#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "Default install does not install custom cert" \
  test ! -f /usr/local/share/ca-certificates/custom-root-ca.crt

check "Default install does not install custom cert bundle" \
  test ! -f /usr/local/share/ca-certificates/custom-root-ca.bundle.crt

reportResults
