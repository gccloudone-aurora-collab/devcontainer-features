#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readme="${repo_root}/README.md"
src_dir="${repo_root}/src"

mapfile -t feature_metadata_files < <(find "${src_dir}" -mindepth 2 -maxdepth 2 -name devcontainer-feature.json -print | sort)

features_table="$(
  for metadata in "${feature_metadata_files[@]}"; do
    feature_id="$(jq -r '.id' "${metadata}")"
    description="$(jq -r '.description' "${metadata}")"
    printf '| [%s](./src/%s) | %s |\n' "${feature_id}" "${feature_id}" "${description}"
  done
)"

usage_features="$(
  for index in "${!feature_metadata_files[@]}"; do
    metadata="${feature_metadata_files[${index}]}"
    feature_id="$(jq -r '.id' "${metadata}")"
    version="$(jq -r '.version' "${metadata}")"
    major_version="${version%%.*}"
    printf '    "ghcr.io/gccloudone-aurora-collab/devcontainer-features/%s:%s": {}' "${feature_id}" "${major_version}"
    if [ "${index}" -lt "$((${#feature_metadata_files[@]} - 1))" ]; then
      printf ','
    fi
    printf '\n'
  done
)"

tmp_file="$(mktemp)"
awk -v table="${features_table}" -v usage_features="${usage_features}" '
  /^<!-- FEATURES_TABLE_START -->$/ {
    print
    print "| Feature | Description |"
    print "| ------- | ----------- |"
    print table
    in_table = 1
    next
  }
  /^<!-- FEATURES_TABLE_END -->$/ {
    in_table = 0
  }
  /^<!-- USAGE_EXAMPLE_START -->$/ {
    print
    print "```jsonc"
    print "{"
    print "  \"name\": \"my-project-devcontainer\","
    print "  \"image\": \"mcr.microsoft.com/devcontainers/base:ubuntu\","
    print "  \"features\": {"
    print usage_features
    print "  }"
    print "}"
    print "```"
    in_usage = 1
    next
  }
  /^<!-- USAGE_EXAMPLE_END -->$/ {
    in_usage = 0
  }
  !in_table && !in_usage {
    print
  }
' "${readme}" > "${tmp_file}"

mv "${tmp_file}" "${readme}"
