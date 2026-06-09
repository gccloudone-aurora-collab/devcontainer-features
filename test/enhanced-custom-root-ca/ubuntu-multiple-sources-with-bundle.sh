#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "First cert installed" \
  test -f /usr/local/share/ca-certificates/custom.sub.crt

check "Second cert installed" \
  test -f /usr/local/share/ca-certificates/custom-1.sub.crt

check "First cert linked" \
  test -L /etc/ssl/certs/custom.sub.pem

check "Second cert linked" \
  test -L /etc/ssl/certs/custom-1.sub.pem

check "Multiple cert bundle installed" \
  test -f /usr/local/share/ca-certificates/custom.bundle.crt

check "Multiple cert bundle linked" \
  test -L /etc/ssl/certs/custom.bundle.pem

reportResults
