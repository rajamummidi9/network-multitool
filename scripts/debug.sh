#!/usr/bin/env bash
# One-command network debug — Docker or Kubernetes.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/rajamummidi9/network-multitool/main/scripts/debug.sh | bash
#   curl -fsSL ... | bash -s k8s
#   curl -fsSL ... | bash -s docker extra
set -euo pipefail

IMAGE="rajamummidi9/network-multitool"
TAG="${TAG:-latest}"
MODE="${1:-k8s}"

case "${MODE}" in
  docker|d)
    VARIANT="${2:-latest}"
    [[ "${VARIANT}" == "extra" || "${VARIANT}" == "openshift" ]] && TAG="${VARIANT}"
    echo "Starting Docker debug shell (${IMAGE}:${TAG})..."
    exec docker run --rm -it "${IMAGE}:${TAG}" /bin/bash
    ;;
  k8s|k|kubectl)
    VARIANT="${2:-latest}"
    [[ "${VARIANT}" == "extra" || "${VARIANT}" == "openshift" ]] && TAG="${VARIANT}"
    POD="netdebug-$(date +%s | tail -c 6)"
    echo "Starting debug pod ${POD} (${IMAGE}:${TAG})..."
    kubectl run "${POD}" \
      --rm -it --restart=Never \
      --image="${IMAGE}:${TAG}" \
      --image-pull-policy=Always \
      --overrides='{"spec":{"containers":[{"name":"'"${POD}"'","image":"'"${IMAGE}:${TAG}"'","stdin":true,"tty":true,"command":["/bin/bash"],"securityContext":{"capabilities":{"add":["NET_ADMIN"]}}}]}}' \
      -- /bin/bash
    ;;
  apply|manifest)
    echo "Applying debug pod manifest from GitHub..."
    kubectl apply -f https://raw.githubusercontent.com/rajamummidi9/network-multitool/main/kubernetes/debug-pod.yaml
    echo "Run: kubectl exec -it network-multitool-debug -- /bin/bash"
    ;;
  *)
    cat <<EOF
Network MultiTool — quick debug

  bash debug.sh              # Kubernetes (default)
  bash debug.sh k8s extra    # K8s with extra tools
  bash debug.sh docker       # Docker local shell
  bash debug.sh apply        # Apply debug pod manifest

Image: ${IMAGE}
Docs:  https://github.com/rajamummidi9/network-multitool
EOF
    ;;
esac
