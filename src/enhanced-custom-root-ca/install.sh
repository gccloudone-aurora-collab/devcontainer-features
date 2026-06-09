#!/bin/sh

set -e

fatal() {
  echo "⛔ " "$@" >&2
  exit 1
}

# Satisfy ShellCheck by providing defaults for variables injected by the DevContainer
NAME="${NAME:-custom-root-ca.crt}"
SOURCES="${SOURCES:-}"
FINGERPRINTS="${FINGERPRINTS:-}"
BUNDLE="${BUNDLE:-true}"
ALLOWINSECUREDOWNLOAD="${ALLOWINSECUREDOWNLOAD:-false}"

if [ -z "${SOURCES}" ]; then
  echo "ℹ️ No certificate sources were provided. Skipping custom root CA installation."
  exit 0
fi

check_packages() {
  if ! command -v curl > /dev/null 2>&1 && ! command -v wget > /dev/null 2>&1; then
    echo "pkg: Downloader not found. Attempting to install 'curl'..."

    if [ -x "$(command -v apt-get)" ]; then
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -y
      apt-get install -y --no-install-recommends curl ca-certificates
    elif [ -x "$(command -v apk)" ]; then
      apk add --no-cache curl ca-certificates
    else
      fatal "Neither curl nor wget found, and could not install curl automatically."
    fi
  fi

  if ! command -v update-ca-certificates > /dev/null 2>&1; then
    echo "pkg: 'update-ca-certificates' not found. Installing 'ca-certificates'..."

    if [ -x "$(command -v apt-get)" ]; then
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -y
      apt-get install -y --no-install-recommends ca-certificates
    elif [ -x "$(command -v apk)" ]; then
      apk add --no-cache ca-certificates
    else
      fatal "update-ca-certificates is required but could not be installed automatically."
    fi
  fi

  if [ -n "${FINGERPRINTS}" ] && ! command -v openssl > /dev/null 2>&1; then
    echo "pkg: 'openssl' not found. Installing 'openssl' because certificate fingerprints were provided..."

    if [ -x "$(command -v apt-get)" ]; then
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -y
      apt-get install -y --no-install-recommends openssl
    elif [ -x "$(command -v apk)" ]; then
      apk add --no-cache openssl
    else
      fatal "openssl is required to verify certificate fingerprints but could not be installed automatically."
    fi
  fi
}

set_insecure_download_flag() {
  downloader="$1"
  flag=""

  if [ "${ALLOWINSECUREDOWNLOAD}" = "true" ]; then
    echo "🙈 Allowing insecure download without TLS certificate validation"

    case "$downloader" in
      curl)
        flag="--insecure"
        ;;
      wget)
        flag="--no-check-certificate"
        ;;
      *)
        fatal "Incorrect downloader executable [${downloader}]"
        ;;
    esac
  fi
}

download() {
  url_source="$1"
  cert_name="$2"
  user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

  echo "⏬ Downloading certificate from ${url_source}"
  echo "📁 Save certificate to ${cert_name}"

  if [ -x "$(command -v curl)" ]; then
    set_insecure_download_flag curl
    curl \
      -4 \
      -vfL \
      --user-agent "$user_agent" \
      --connect-timeout 15 \
      --max-time 60 \
      --retry 3 \
      --retry-delay 3 \
      --retry-all-errors \
      $flag \
      "$url_source" \
      -o "$cert_name"

  elif [ -x "$(command -v wget)" ]; then
    set_insecure_download_flag wget
    wget \
      -4 \
      --user-agent="$user_agent" \
      -T 60 \
      -t 3 \
      $flag \
      "$url_source" \
      -O "$cert_name"

  else
    fatal "Could not find curl or wget, please install one."
  fi
}

verify_fingerprint() {
  file_path="$1"
  expected="$2"

  # Skip verification if no fingerprint was provided for this index
  if [ -z "$expected" ]; then
    return 0
  fi

  echo "🔍 Verifying SHA-256 fingerprint for ${file_path}..."

  if ! command -v openssl > /dev/null 2>&1; then
    fatal "openssl is required to verify certificate fingerprints but could not be found."
  fi

  actual=$(openssl x509 -in "$file_path" -noout -sha256 -fingerprint | cut -d'=' -f2)

  # Convert both strings to uppercase for a safe, case-insensitive comparison
  actual_upper=$(echo "$actual" | tr '[:lower:]' '[:upper:]')
  expected_upper=$(echo "$expected" | tr '[:lower:]' '[:upper:]')

  if [ "$actual_upper" != "$expected_upper" ]; then
    fatal "Fingerprint mismatch for ${file_path}! Expected [${expected_upper}], but got [${actual_upper}]."
  else
    echo "✅ Fingerprint matches!"
  fi
}

create_bundle() {
  bundle_filename="$1"

  if [ "${BUNDLE}" = "true" ]; then
    bundle="${bundle_filename}.bundle.crt"
    echo "📦 Creating certificate bundle ${bundle}"

    # Safely combine files using a temporary file
    temp_bundle=$(mktemp)
    for cert in "${dest_dir}/${bundle_filename}"*; do
      if [ -f "$cert" ]; then
        cat "$cert" >> "$temp_bundle"
      fi
    done
    mv "$temp_bundle" "${dest_dir}/${bundle}"
  fi
}

echo "🔛 Activating feature '🔒 custom-root-ca'"

check_packages

counter=0
filename=$(echo "$NAME" | cut -d . -f 1)
extension=$(echo "$NAME" | cut -d . -f 2-)
certs=$(echo "$SOURCES" | tr ',' '\n')
dest_dir=/usr/local/share/ca-certificates

mkdir -p "$dest_dir"

for i in $certs; do
  # Extract the Nth fingerprint corresponding to the Nth URL
  idx=$((counter + 1))
  expected_fp=$(echo "$FINGERPRINTS" | awk -v col="$idx" -F',' '{print $col}')

  if [ "$counter" -eq 0 ]; then
    dest_file="${dest_dir}/${filename}.${extension}"
  else
    dest_file="${dest_dir}/${filename}-${counter}.${extension}"
  fi

  download "${i}" "${dest_file}"
  verify_fingerprint "${dest_file}" "${expected_fp}"

  counter=$((counter + 1))
done

create_bundle "$filename"

update-ca-certificates
