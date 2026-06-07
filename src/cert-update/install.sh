#!/usr/bin/env bash
set -euo pipefail

install_dependencies() {
  echo "Certificate update commands not found. Installing ca-certificates package..."
  if command -v apt-get > /dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y --no-install-recommends ca-certificates
  elif command -v dnf > /dev/null 2>&1; then
    dnf install -y ca-certificates
  elif command -v yum > /dev/null 2>&1; then
    yum install -y ca-certificates
  elif command -v apk > /dev/null 2>&1; then
    apk add --no-cache ca-certificates
  else
    echo "Warning: Package manager not found. Cannot install ca-certificates."
  fi
}

# Ensure required CA certificate tools exist before proceeding
if ! command -v update-ca-certificates > /dev/null 2>&1 && ! command -v update-ca-trust > /dev/null 2>&1; then
  install_dependencies
fi

detect_cert_directory() {
  if [ -n "${CERTDIRECTORY:-}" ]; then
    printf '%s\n' "${CERTDIRECTORY}"
    return 0
  fi

  if command -v update-ca-certificates > /dev/null 2>&1; then
    printf '%s\n' "/usr/local/share/ca-certificates"
    return 0
  fi

  if command -v update-ca-trust > /dev/null 2>&1; then
    printf '%s\n' "/etc/pki/ca-trust/source/anchors"
    return 0
  fi

  echo "No supported CA update command found; cannot detect certificate directory" >&2
  return 1
}

update_trust_store() {
  if command -v update-ca-certificates > /dev/null 2>&1; then
    update-ca-certificates
  elif command -v update-ca-trust > /dev/null 2>&1; then
    update-ca-trust extract
  else
    echo "No supported CA update command found"
    exit 1
  fi
}

count_certificates() {
  find "$1" -maxdepth 1 -type f -name '*.crt' | wc -l | tr -d ' '
}

CERT_DIR="$(detect_cert_directory)"
SOURCE_CERT_DIR="${SOURCECERTIFICATEDIRECTORY:-}"
REQUIRED="${REQUIRED:-true}"
TEST_CERTIFICATE="${TESTCERTIFICATE:-false}"

echo "Activating cert-update"
echo "Certificate directory: ${CERT_DIR}"

mkdir -p "${CERT_DIR}"

if [ "${TEST_CERTIFICATE}" = "true" ]; then
  echo "Generating cert-update test CA"

  if ! command -v openssl > /dev/null 2>&1; then
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

if [ -n "${SOURCE_CERT_DIR}" ]; then
  if [ ! -d "${SOURCE_CERT_DIR}" ]; then
    echo "Source certificate directory ${SOURCE_CERT_DIR} does not exist; skipping source copy"
    if [ "$(count_certificates "${CERT_DIR}")" = "0" ]; then
      exit 0
    fi
  else
    SOURCE_CERT_COUNT="$(count_certificates "${SOURCE_CERT_DIR}")"
    if [ "${SOURCE_CERT_COUNT}" = "0" ]; then
      echo "No .crt files found in source certificate directory ${SOURCE_CERT_DIR}; skipping source copy"
      if [ "$(count_certificates "${CERT_DIR}")" = "0" ]; then
        exit 0
      fi
    else
      echo "Copying ${SOURCE_CERT_COUNT} certificate file(s) from ${SOURCE_CERT_DIR} to ${CERT_DIR}"
      find "${SOURCE_CERT_DIR}" -maxdepth 1 -type f -name '*.crt' -exec cp {} "${CERT_DIR}/" \;
    fi
  fi
fi

CERT_COUNT="$(count_certificates "${CERT_DIR}")"

if [ "${CERT_COUNT}" = "0" ]; then
  if [ "${REQUIRED}" = "true" ]; then
    echo "No .crt files found in ${CERT_DIR}"
    exit 1
  fi

  echo "No .crt files found in ${CERT_DIR}; required=false, skipping"
  exit 0
fi

echo "Found ${CERT_COUNT} certificate file(s)"

update_trust_store

echo "cert-update complete"
