#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "Cert installed" test -f /usr/local/share/ca-certificates/custom-root-ca.crt
check "Cert linked" [ -L /etc/ssl/certs/custom-root-ca.pem ]

reportResults
