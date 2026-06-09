#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "Default cert installed" \
  test -f /usr/local/share/ca-certificates/custom-root-ca.crt

check "Default cert trusted/generated" \
  sh -c "ls /etc/ssl/certs | grep -E 'custom-root-ca|ca-cert-custom-root-ca'"

check "Default cert bundle not installed" \
  test ! -f /usr/local/share/ca-certificates/custom-root-ca.bundle.crt

check "Default cert bundle not trusted/generated" \
  sh -c "! ls /etc/ssl/certs | grep -E 'custom-root-ca\\.bundle|ca-cert-custom-root-ca\\.bundle'"

reportResults
