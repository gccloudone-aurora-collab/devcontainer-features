#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "First cert installed" \
  test -f /usr/local/share/ca-certificates/custom.sub.crt

check "Second cert installed" \
  test -f /usr/local/share/ca-certificates/custom-1.sub.crt

check "First cert trusted/generated" \
  sh -c "ls /etc/ssl/certs | grep -E 'custom\\.sub|ca-cert-custom\\.sub'"

check "Second cert trusted/generated" \
  sh -c "ls /etc/ssl/certs | grep -E 'custom-1\\.sub|ca-cert-custom-1\\.sub'"

check "Multiple cert bundle installed" \
  test -f /usr/local/share/ca-certificates/custom.bundle.crt

check "Multiple cert bundle trusted/generated" \
  sh -c "ls /etc/ssl/certs | grep -E 'custom\\.bundle|ca-cert-custom\\.bundle'"

reportResults
