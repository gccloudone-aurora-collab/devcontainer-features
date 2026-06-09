#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "Custom cert installed" \
  test -f /usr/local/share/ca-certificates/custom.crt

check "Custom cert trusted/generated" \
  sh -c "ls /etc/ssl/certs | grep -E 'custom|ca-cert-custom'"

check "Custom cert bundle installed" \
  test -f /usr/local/share/ca-certificates/custom.bundle.crt

check "Custom cert bundle trusted/generated" \
  sh -c "ls /etc/ssl/certs | grep -E 'custom\\.bundle|ca-cert-custom\\.bundle'"

reportResults
