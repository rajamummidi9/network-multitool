#!/usr/bin/env bash
set -euo pipefail

IMAGE="rajamummidi9/network-multitool"
TAG="${1:-latest}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

echo "==> Building ${IMAGE}:${TAG}"
docker build -t "${IMAGE}:${TAG}" .

echo "==> Tagging ${IMAGE}:latest"
if [[ "${TAG}" != "latest" ]]; then
  docker tag "${IMAGE}:${TAG}" "${IMAGE}:latest"
fi

echo "==> Pushing ${IMAGE}:${TAG}"
docker push "${IMAGE}:${TAG}"

if [[ "${TAG}" != "latest" ]]; then
  echo "==> Pushing ${IMAGE}:latest"
  docker push "${IMAGE}:latest"
fi

echo "==> Done. Image available at:"
echo "    docker pull ${IMAGE}:${TAG}"
