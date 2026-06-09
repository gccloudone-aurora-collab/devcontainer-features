#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "Custom cert installed" \
  test -f /usr/local/share/ca-certificates/custom.crt

check "Custom cert linked" \
  test -L /etc/ssl/certs/custom.pem

check "Custom cert bundle installed" \
  test -f /usr/local/share/ca-certificates/custom.bundle.crt

check "Custom cert bundle linked" \
  test -L /etc/ssl/certs/custom.bundle.pem

reportResults
