#!/bin/bash
# Test:
# devcontainer features test --features cert-update --remote-user root --skip-scenarios --base-image mcr.microsoft.com/devcontainers/base:ubuntu

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

os_release_value() {
  awk -F= -v key="$1" '$1 == key { value = $2; sub(/^"/, "", value); sub(/"$/, "", value); print value; exit }' /etc/os-release
}

os_summary() {
  if [ -r /etc/os-release ]; then
    local pretty_name
    local os_id
    local version_id

    pretty_name="$(os_release_value PRETTY_NAME)"
    os_id="$(os_release_value ID)"
    version_id="$(os_release_value VERSION_ID)"

    printf '%s (%s %s)' "${pretty_name:-unknown}" "${os_id:-unknown}" "${version_id:-unknown}"
  else
    uname -a
  fi
}

first_existing_bundle() {
  for bundle in "$@"; do
    if [ -e "${bundle}" ]; then
      printf '%s\n' "${bundle}"
      return 0
    fi
  done

  return 1
}

detect_trust_store_layout() {
  local debian_cert_dir="/usr/local/share/ca-certificates"
  local debian_bundle="/etc/ssl/certs/ca-certificates.crt"
  local pki_cert_dir="/etc/pki/ca-trust/source/anchors"
  local pki_default_bundle="/etc/pki/tls/certs/ca-bundle.crt"

  if command -v update-ca-certificates > /dev/null 2>&1 || [ -d "${debian_cert_dir}" ]; then
    TRUST_STORE_LAYOUT="debian"
    CERT_DIR="${debian_cert_dir}"
    CA_BUNDLE="${debian_bundle}"
    return 0
  fi

  if command -v update-ca-trust > /dev/null 2>&1 || [ -d "${pki_cert_dir}" ]; then
    TRUST_STORE_LAYOUT="pki"
    CERT_DIR="${pki_cert_dir}"
    CA_BUNDLE="$(first_existing_bundle \
      "${pki_default_bundle}" \
      "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem" \
      "/etc/ssl/certs/ca-bundle.crt" || printf '%s\n' "${pki_default_bundle}")"
    return 0
  fi

  echo "Unsupported trust-store layout. OS: ${OS_SUMMARY}; expected either ${debian_cert_dir} with ${debian_bundle}, or ${pki_cert_dir} with ${pki_default_bundle}" >&2
  return 1
}

OS_SUMMARY="$(os_summary)"
detect_trust_store_layout
TEST_CA_CERT="${CERT_DIR}/cert-update-test-ca.crt"

check "Test cert installed (OS: ${OS_SUMMARY}; expected cert: ${TEST_CA_CERT})" \
  test -f "${TEST_CA_CERT}"

check "CA bundle exists (OS: ${OS_SUMMARY}; expected bundle: ${CA_BUNDLE})" \
  test -f "${CA_BUNDLE}"

check "CA bundle is readable (OS: ${OS_SUMMARY}; expected bundle: ${CA_BUNDLE})" \
  test -r "${CA_BUNDLE}"

if [ "${TRUST_STORE_LAYOUT}" = "debian" ]; then
  check "Test cert linked into /etc/ssl/certs (OS: ${OS_SUMMARY})" \
    bash -c "ls -alh /etc/ssl/certs | grep -E 'cert-update-test-ca|cert-update_Test_CA'"
else
  echo "Skipping /etc/ssl/certs symlink assertion for ${TRUST_STORE_LAYOUT} trust-store layout. OS: ${OS_SUMMARY}; bundle: ${CA_BUNDLE}"
fi

check "OpenSSL trusts test cert through detected bundle (OS: ${OS_SUMMARY}; CAfile: ${CA_BUNDLE})" \
  openssl verify \
  -CAfile "${CA_BUNDLE}" \
  "${TEST_CA_CERT}"

reportResults
