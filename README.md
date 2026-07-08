# Network MultiTool

Multi-arch network troubleshooting image for Docker, Kubernetes, and OpenShift.

Maintained by **rajamummidi9** — mummidiraja9@gmail.com

| Resource | URL |
|----------|-----|
| Docker image | `rajamummidi9/network-multitool` |
| GitHub | https://github.com/rajamummidi9/network-multitool |
| Docker Hub | https://hub.docker.com/r/rajamummidi9/network-multitool |

## Image variants

| Tag | Size (approx) | Use case |
|-----|---------------|----------|
| `latest`, `minimal` | ~40 MB | Default — lean core toolkit |
| `extra` | ~120 MB | socat, nc, iperf3, ethtool, lsof, traceroute |
| `openshift` | ~40 MB | Non-root, ports **1180** / **11443** |

**Platforms:** `linux/amd64`, `linux/arm64` (published via GitHub Actions)

## Quick start

```bash
# Minimal (default)
docker run --rm -it rajamummidi9/network-multitool:latest /bin/bash

# Extra toolkit
docker run --rm -it rajamummidi9/network-multitool:extra /bin/bash

# OpenShift-compatible
docker run --rm -it -p 1180:1180 rajamummidi9/network-multitool:openshift /bin/bash
```

### Kubernetes

```bash
kubectl apply -k kubernetes/                              # minimal deployment
kubectl apply -f kubernetes/debug-pod.yaml                # debug pod
kubectl apply -f kubernetes/openshift-deployment.yaml     # OpenShift variant
kubectl apply -f kubernetes/daemonset.yaml                # hostNetwork DaemonSet
```

## Build locally

```bash
make build-minimal    # ~40 MB
make build-extra      # ~120 MB
make build-openshift
```

## Multi-arch push (requires Docker Hub login + buildx)

```bash
./scripts/build-and-push.sh minimal latest
./scripts/build-and-push.sh extra
./scripts/build-and-push.sh openshift
./scripts/build-and-push.sh all latest
```

## CI/CD

See [docs/CI-SETUP.md](docs/CI-SETUP.md) for GitHub Actions secrets (`DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`).

## Tools by variant

**minimal / latest:** bash, curl, wget, dig, nslookup, ping, mtr, tcpdump, jq, ip, ifconfig, netstat, telnet, nginx, openssl, ssh, rsync

**extra (adds):** socat, nc, iperf3, ethtool, lsof, traceroute

## License

MIT — Copyright (c) 2026 rajamummidi9
