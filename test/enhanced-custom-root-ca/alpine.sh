#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "Cert installed" test -f /usr/local/share/ca-certificates/custom-root-ca.crt
check "Cert trusted/generated" bash -c "ls /etc/ssl/certs | grep -E 'custom-root-ca|ca-cert-custom-root-ca'"

reportResults
