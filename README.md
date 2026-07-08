# Network MultiTool

A compact Docker image packed with networking utilities for Kubernetes and container troubleshooting. Includes nginx (HTTP/HTTPS), curl, dig, ping, tcpdump, mtr, socat, iperf3, and more.

Maintained by **rajamummidi9** — mummidiraja9@gmail.com

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

# List bundled tools
docker run --rm rajamummidi9/network-multitool /docker/tools-check.sh

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
kubectl apply -k kubernetes/

# One-off debug pod (sleep infinity, exec in)
kubectl apply -f kubernetes/debug-pod.yaml
kubectl exec -it network-multitool-debug -- /bin/bash

# DaemonSet on every node (hostNetwork, ports 1180/11443)
kubectl apply -f kubernetes/daemonset.yaml
```

## Build and push

```bash
make build
make push TAG=latest
# or
./scripts/build-and-push.sh v1.1.0
```

## Included tools

| Category | Tools |
|----------|-------|
| DNS | `dig`, `nslookup`, `host` |
| HTTP/TLS | `curl`, `wget`, `nginx`, `openssl` |
| Connectivity | `ping`, `traceroute`, `tcptraceroute`, `mtr`, `telnet` |
| Ports & sockets | `nc` (nmap-ncat), `socat`, `ss`, `netstat`, `lsof` |
| Capture & trace | `tcpdump`, `ethtool` |
| Throughput | `iperf3` |
| Remote copy | `rsync`, `scp`/`ssh` (openssh-client) |
| Shell & parse | `bash`, `jq`, `ip`, `ifconfig`, `procps` |

Run `/docker/tools-check.sh` inside the container for the full list.

## Troubleshooting recipes

```bash
# DNS lookup
dig +short my-service.namespace.svc.cluster.local

# Test TCP to a service
nc -zv my-service 8080

# HTTP health check
curl -v http://my-service:8080/health

# TLS handshake
openssl s_client -connect my-service:443 -servername my-service

# Bandwidth test (needs iperf3 server on target)
iperf3 -c iperf-server -p 5201

# Port relay (debug sidecar pattern)
socat TCP-LISTEN:8080,fork TCP:backend:8080

# Packet capture (short sample)
tcpdump -i any -c 20 host 10.0.0.1
```

## Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `HTTP_PORT` | `80` | nginx HTTP listen port |
| `HTTPS_PORT` | `443` | nginx HTTPS listen port |

## CI/CD (optional)

Add these GitHub repository secrets for automated builds on push:

| Secret | Value |
|--------|-------|
| `DOCKERHUB_USERNAME` | `rajamummidi9` |
| `DOCKERHUB_TOKEN` | Docker Hub access token |

## Optional future additions

Not included to keep the image small (~90–100 MB). Add if your team needs them:

| Tool | Use case | Alpine package |
|------|----------|----------------|
| `nmap` | Port scanning | `nmap` |
| `httpie` | Friendly HTTP CLI | `httpie` |
| `grpcurl` | gRPC debugging | manual binary |
| `redis-cli` | Redis connectivity | `redis` |
| `postgresql-client` | DB connectivity | `postgresql-client` |
| `kafkacat` | Kafka connectivity | `kcat` |

## License

MIT — see [LICENSE](LICENSE). Copyright (c) 2026 rajamummidi9.
