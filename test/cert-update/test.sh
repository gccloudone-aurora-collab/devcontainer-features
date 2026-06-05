#!/bin/bash
# Test:
# devcontainer features test --features cert-roller --remote-user root --skip-scenarios --base-image mcr.microsoft.com/devcontainers/base:ubuntu

set -e

source dev-container-features-test-lib

check "Test cert installed" \
  test -f /usr/local/share/ca-certificates/cert-roller-test-ca.crt

check "CA bundle exists" \
  test -f /etc/ssl/certs/ca-certificates.crt

check "CA bundle is readable" \
  test -r /etc/ssl/certs/ca-certificates.crt

check "Test cert linked into /etc/ssl/certs" \
  bash -c "ls -alh /etc/ssl/certs | grep -E 'cert-roller-test-ca|Cert_Roller_Test_CA'"

check "OpenSSL trusts test cert through generated bundle" \
  openssl verify \
    -CAfile /etc/ssl/certs/ca-certificates.crt \
    /usr/local/share/ca-certificates/cert-roller-test-ca.crt

reportResults