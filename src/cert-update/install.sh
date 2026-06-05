#!/usr/bin/env bash
set -euo pipefail

CERT_DIR="${CERTDIRECTORY:-/usr/local/share/ca-certificates}"
REQUIRED="${REQUIRED:-true}"
TEST_CERTIFICATE="${TESTCERTIFICATE:-false}"

echo "Activating cert-update"
echo "Certificate directory: ${CERT_DIR}"

mkdir -p "${CERT_DIR}"

if [ "${TEST_CERTIFICATE}" = "true" ]; then
  echo "Generating cert-update test CA"

  if ! command -v openssl >/dev/null 2>&1; then
    echo "openssl is required when testCertificate=true"
    exit 1
  fi

  openssl req \
    -x509 \
    -newkey rsa:2048 \
    -sha256 \
    -days 365 \
    -nodes \
    -subj "/CN=cert-update Test CA/O=cert-update" \
    -keyout /tmp/cert-update-test-ca.key \
    -out "${CERT_DIR}/cert-update-test-ca.crt"
fi

CERT_COUNT="$(find "${CERT_DIR}" -maxdepth 1 -type f -name '*.crt' | wc -l | tr -d ' ')"

if [ "${CERT_COUNT}" = "0" ]; then
  if [ "${REQUIRED}" = "true" ]; then
    echo "No .crt files found in ${CERT_DIR}"
    exit 1
  fi

  echo "No .crt files found in ${CERT_DIR}; required=false, skipping"
  exit 0
fi

echo "Found ${CERT_COUNT} certificate file(s)"

if command -v update-ca-certificates >/dev/null 2>&1; then
  update-ca-certificates
elif command -v update-ca-trust >/dev/null 2>&1; then
  update-ca-trust extract
else
  echo "No supported CA update command found"
  exit 1
fi

echo "cert-update complete"
