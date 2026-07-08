# One Container to Debug Any Kubernetes Network Issue

*How I built a multi-arch network troubleshooting image for Docker, Kubernetes, and OpenShift.*

---

## The problem every DevOps engineer knows

You get paged. A service can't reach its database. Or DNS is flaky. Or an ingress returns a 502 and nobody knows why.

The first instinct is to `exec` into a pod and start poking around:

```bash
kubectl exec -it my-app -- sh
```

…and then you discover the container is a stripped-down distroless or Alpine image with **no `curl`, no `dig`, no `ping`, no `nc`**. Nothing. You can't install anything either, because there's no package manager or no network egress to the registry.

So you waste 20 minutes finding *any* way to run a test, when you should be finding the actual root cause.

## The fix: a purpose-built debug container

The idea isn't new — the well-known [`wbitt/network-multitool`](https://github.com/wbitt/Network-MultiTool) (formerly Praqma) pioneered it. I built my own maintained fork so I could:

- keep it **lightweight** and **multi-arch** (works on ARM cloud nodes and Apple Silicon),
- ship **variants** for different needs (minimal / extra / OpenShift),
- and understand every layer of the build end-to-end.

The result: **[`rajamummidi9/network-multitool`](https://hub.docker.com/r/rajamummidi9/network-multitool)** — one image, every tool you reach for during an incident.

## What's inside

| Variant | Size | What you get |
|---------|------|--------------|
| `minimal` / `latest` | ~117 MB | curl, wget, dig, nslookup, ping, mtr, tcpdump, traceroute, jq, ip, netstat, telnet, ssh, rsync, nginx |
| `extra` | ~120 MB | everything above **+** socat, nc, iperf3, ethtool, lsof |
| `openshift` | ~119 MB | non-root, runs on locked-down OpenShift SCCs, listens on 1180/11443 |

All variants are published for **`linux/amd64`** and **`linux/arm64`**.

## Why it runs an nginx web server

This surprises people. Why does a *debug* image run a web server?

Because a container needs a long-running process to stay alive. Instead of hacks like `sleep infinity`, nginx keeps the container `Running` so you can simply `exec` into it whenever you need to. As a bonus, you get an HTTP/HTTPS endpoint to test connectivity *to* the pod as well.

## How to use it

### Quick debug pod

```bash
kubectl run multitool --image=rajamummidi9/network-multitool -it -- bash
```

### Test connectivity from inside the cluster

```bash
# DNS resolution
dig +short my-service.my-namespace.svc.cluster.local

# TCP reachability
nc -zv my-service 8080

# HTTP health check
curl -v http://my-service:8080/health

# TLS handshake inspection
openssl s_client -connect my-service:443 -servername my-service

# Packet capture
tcpdump -i any -c 20 host 10.0.0.1

# Bandwidth test between pods
iperf3 -c iperf-server
```

### Troubleshoot node networking with a DaemonSet

Sometimes the problem is on the **node**, not the pod. A DaemonSet with `hostNetwork: true` puts a debug tool on every node — no SSH required:

```bash
kubectl apply -f kubernetes/daemonset.yaml
kubectl exec -it <daemonset-pod> -- bash
```

This is the *cloud-native* way to debug hosts: immutable infrastructure, nothing installed on the node itself.

## How I built it

The interesting engineering decisions:

1. **Multi-stage `Dockerfile.extra`** — the extra variant builds `FROM` the minimal image, so the two stay in sync and share layers.
2. **Multi-arch via `docker buildx` + GitHub Actions** — one `git push` produces `amd64` and `arm64` images automatically.
3. **OpenShift compatibility** — OpenShift runs containers as a random non-root UID. The image sets `setuid` on tools like `tcpdump` and creates a runtime `/etc/passwd` entry so everything still works under a restricted SCC.
4. **A `HEALTHCHECK`** so orchestrators know the container is actually healthy.

The full source, Kubernetes manifests, `Makefile`, and CI workflow are on GitHub.

## Try it

```bash
docker pull rajamummidi9/network-multitool
```

- **GitHub:** https://github.com/rajamummidi9/network-multitool
- **Docker Hub:** https://hub.docker.com/r/rajamummidi9/network-multitool

If it saves you even one frantic 2 a.m. debugging session, it did its job. Feedback and PRs welcome.

---

*Built with ❤️ for the DevOps community. Credit to the original [Praqma/wbitt Network-MultiTool](https://github.com/wbitt/Network-MultiTool) for the concept.*
