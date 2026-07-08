#!/usr/bin/env bash
# Retag and push all variants to netkit/network-multitool (multi-arch via buildx).
# Prerequisites: Docker Hub org "netkit" created + docker login
set -euo pipefail

OLD_IMAGE="rajamummidi9/network-multitool"
NEW_IMAGE="netkit/network-multitool"
KEEP_OLD=false

for arg in "$@"; do
  [[ "$arg" == "--keep-old" ]] && KEEP_OLD=true
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

docker buildx inspect multitool-builder >/dev/null 2>&1 || \
  docker buildx create --name multitool-builder --use --bootstrap

build_push() {
  local dockerfile=$1
  shift
  local tags=("$@")
  local tag_args=()
  for t in "${tags[@]}"; do
    tag_args+=(-t "${NEW_IMAGE}:${t}")
    [[ "${KEEP_OLD}" == "true" ]] && tag_args+=(-t "${OLD_IMAGE}:${t}")
  done
  echo "==> Building ${dockerfile} -> ${tags[*]}"
  docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --file "${dockerfile}" \
    "${tag_args[@]}" \
    --push .
}

build_push Dockerfile latest minimal
build_push Dockerfile.extra extra
build_push Dockerfile.openshift openshift

echo ""
echo "Done! New image:"
echo "  docker pull ${NEW_IMAGE}:latest"
echo ""
echo "Quick test:"
echo "  kubectl run netkit --rm -it --image=${NEW_IMAGE} -- bash"
