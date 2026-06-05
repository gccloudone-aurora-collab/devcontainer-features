#!/bin/bash

set -e

source dev-container-features-test-lib

check "Corporate cert is not present" \
  bash -c "! test -f /usr/local/share/ca-certificates/corporate.crt"

check "System CA bundle still exists" \
  test -f /etc/ssl/certs/ca-certificates.crt

check "System CA bundle is readable" \
  test -r /etc/ssl/certs/ca-certificates.crt

reportResults