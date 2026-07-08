#!/usr/bin/env bash
set -euo pipefail

IMAGE="rajamummidi9/network-multitool"
VARIANT="${1:-minimal}"
TAG="${2:-latest}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

case "${VARIANT}" in
  minimal) DOCKERFILE="Dockerfile" ;;
  extra)   DOCKERFILE="Dockerfile.extra" ;;
  openshift) DOCKERFILE="Dockerfile.openshift" ;;
  all)
    "${BASH_SOURCE[0]}" minimal "${TAG}"
    "${BASH_SOURCE[0]}" extra "${TAG}"
    "${BASH_SOURCE[0]}" openshift "${TAG}"
    exit 0
    ;;
  *) echo "Unknown variant: ${VARIANT} (use minimal|extra|openshift|all)" >&2; exit 1 ;;
esac

cd "$ROOT_DIR"

docker buildx inspect multitool-builder >/dev/null 2>&1 || \
  docker buildx create --name multitool-builder --use

IMAGE_TAG="${IMAGE}"
if [[ "${VARIANT}" == "minimal" && "${TAG}" == "latest" ]]; then
  IMAGE_TAG="${IMAGE}:latest"
elif [[ "${VARIANT}" == "minimal" ]]; then
  IMAGE_TAG="${IMAGE}:${TAG}"
else
  IMAGE_TAG="${IMAGE}:${VARIANT}"
  [[ "${TAG}" != "latest" ]] && IMAGE_TAG="${IMAGE}:${TAG}-${VARIANT}"
fi

echo "==> Building ${IMAGE_TAG} (${DOCKERFILE})"
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --file "${DOCKERFILE}" \
  --tag "${IMAGE_TAG}" \
  --push \
  .

echo "==> Done: docker pull ${IMAGE_TAG}"
