#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readme="${repo_root}/README.md"
src_dir="${repo_root}/src"

features_table="$(
  find "${src_dir}" -mindepth 2 -maxdepth 2 -name devcontainer-feature.json -print \
    | sort \
    | while read -r metadata; do
        feature_id="$(jq -r '.id' "${metadata}")"
        description="$(jq -r '.description' "${metadata}")"
        printf '| [%s](./src/%s) | %s |\n' "${feature_id}" "${feature_id}" "${description}"
      done
)"

tmp_file="$(mktemp)"
awk -v table="${features_table}" '
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
  !in_table {
    print
  }
' "${readme}" > "${tmp_file}"

mv "${tmp_file}" "${readme}"
