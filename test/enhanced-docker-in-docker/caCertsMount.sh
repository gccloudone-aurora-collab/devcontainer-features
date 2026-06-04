#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

check "docker-buildx" docker buildx version
check "proxy-builder-exists" bash -c "for _ in \$(seq 1 60); do docker buildx inspect proxy-builder >/dev/null 2>&1 && exit 0; sleep 2; done; docker buildx inspect proxy-builder"
check "proxy-builder-selected" bash -c "for _ in \$(seq 1 60); do docker buildx ls | grep -E '^proxy-builder\\*?[[:space:]]' && exit 0; sleep 2; done; docker buildx ls | grep -E '^proxy-builder\\*?[[:space:]]'"
check "proxy-builder-running" bash -c "for _ in \$(seq 1 60); do docker buildx inspect proxy-builder --bootstrap 2>/dev/null | grep -E 'Status:[[:space:]]+running' && exit 0; sleep 2; done; docker buildx inspect proxy-builder --bootstrap | grep -E 'Status:[[:space:]]+running'"

check "buildkit-container-exists" bash -c "for _ in \$(seq 1 60); do docker ps --filter name=buildx_buildkit_proxy-builder --format '{{.Names}}' | grep -E '^buildx_buildkit_proxy-builder' && exit 0; sleep 2; done; docker ps --filter name=buildx_buildkit_proxy-builder --format '{{.Names}}' | grep -E '^buildx_buildkit_proxy-builder'"
check "ssl-certs-synced" bash -c "for _ in \$(seq 1 60); do docker exec buildx_buildkit_proxy-builder0 test -d /etc/ssl/certs && docker exec buildx_buildkit_proxy-builder0 find /etc/ssl/certs -type f | grep -q . && exit 0; sleep 2; done; docker exec buildx_buildkit_proxy-builder0 test -d /etc/ssl/certs && docker exec buildx_buildkit_proxy-builder0 find /etc/ssl/certs -type f | grep -q ."
check "ca-certificates-synced" bash -c "for _ in \$(seq 1 60); do docker exec buildx_buildkit_proxy-builder0 test -d /usr/local/share/ca-certificates && exit 0; sleep 2; done; docker exec buildx_buildkit_proxy-builder0 test -d /usr/local/share/ca-certificates"

# Report result
reportResults
