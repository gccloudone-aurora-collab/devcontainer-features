#!/bin/bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

check "Cert installed" test -f /usr/local/share/ca-certificates/custom.crt

check "Cert linked" [ -L /etc/ssl/certs/custom.pem ]

check "No cert bundle" [ ! -f /usr/local/share/ca-certificates/custom.bundle.crt ]

reportResults
