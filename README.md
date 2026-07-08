# Network MultiTool

A compact Docker image packed with networking utilities for Kubernetes and container troubleshooting. Includes nginx (HTTP/HTTPS), curl, dig, ping, tcpdump, mtr, traceroute, jq, wget, and more.

Fork of [Praqma/Network-MultiTool](https://github.com/Praqma/Network-MultiTool). Upstream maintenance moved to [wbitt/Network-MultiTool](https://github.com/wbitt/Network-MultiTool).

| Resource | URL |
|----------|-----|
| Docker image | `rajamummidi9/network-multitool` |
| GitHub | https://github.com/rajamummidi9/network-multitool |
| Docker Hub | https://hub.docker.com/r/rajamummidi9/network-multitool |

## Quick start

### Docker

```bash
# Interactive shell
docker run --rm -it rajamummidi9/network-multitool /bin/bash

# Run nginx on default ports 80/443
docker run -p 8080:80 -p 8443:443 -d rajamummidi9/network-multitool

# Custom ports via env vars
docker run -e HTTP_PORT=1180 -e HTTPS_PORT=11443 \
  -p 1180:1180 -p 11443:11443 -d rajamummidi9/network-multitool
```

### Docker Compose

```bash
docker compose up -d
# HTTP: http://localhost:8080  HTTPS: https://localhost:8443
```

### Kubernetes

```bash
# Deployment + ClusterIP Service
kubectl apply -f kubernetes/deployment.yaml -f kubernetes/service.yaml

# One-off debug pod (sleep infinity, exec in)
kubectl apply -f kubernetes/debug-pod.yaml
kubectl exec -it network-multitool-debug -- /bin/bash

# DaemonSet on every node (hostNetwork, ports 1180/11443)
kubectl apply -f kubernetes/daemonset.yaml
```

## Build and push

```bash
./scripts/build-and-push.sh
# or with a specific tag:
./scripts/build-and-push.sh v1.0.0
```

## Included tools

`bash`, `bind-tools` (dig/nslookup), `busybox-extras` (telnet), `curl`, `iproute2`, `iputils` (ping), `jq`, `mtr`, `net-tools`, `nginx`, `openssl`, `procps`, `tcpdump`, `tcptraceroute`, `wget`

## Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `HTTP_PORT` | `80` | nginx HTTP listen port |
| `HTTPS_PORT` | `443` | nginx HTTPS listen port |

## License

MIT — see [LICENSE](LICENSE). Original work Copyright (c) 2019 Praqma.
