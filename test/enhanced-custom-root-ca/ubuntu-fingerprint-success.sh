#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "Default cert installed" \
  test -f /usr/local/share/ca-certificates/custom-root-ca.crt

check "Default cert linked" \
  test -L /etc/ssl/certs/custom-root-ca.pem

check "Default cert bundle installed" \
  test -f /usr/local/share/ca-certificates/custom-root-ca.bundle.crt

check "Default cert bundle linked" \
  test -L /etc/ssl/certs/custom-root-ca.bundle.pem

reportResults
