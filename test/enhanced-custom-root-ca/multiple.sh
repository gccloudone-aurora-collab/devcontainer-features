#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "Cert 1 installed" test -f /usr/local/share/ca-certificates/custom.sub.crt
check "Cert 2 installed" test -f /usr/local/share/ca-certificates/custom-1.sub.crt

check "Cert 1 trusted/generated" bash -c "ls /etc/ssl/certs | grep -E 'custom\\.sub|ca-cert-custom\\.sub'"
check "Cert 2 trusted/generated" bash -c "ls /etc/ssl/certs | grep -E 'custom-1\\.sub|ca-cert-custom-1\\.sub'"

reportResults
