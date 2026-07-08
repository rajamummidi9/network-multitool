# Quick Start — copy & paste

No install. No clone. Works on any cluster with internet access to Docker Hub.

## Fastest: one command

### Kubernetes (most common)

```bash
kubectl run netdebug --rm -it --restart=Never \
  --image=rajamummidi9/network-multitool \
  --image-pull-policy=Always -- bash
```

With extra tools (`socat`, `nc`, `iperf3`):

```bash
kubectl run netdebug --rm -it --restart=Never \
  --image=rajamummidi9/network-multitool:extra \
  --image-pull-policy=Always -- bash
```

### Docker (local machine)

```bash
docker run --rm -it rajamummidi9/network-multitool bash
```

### Auto script (detects k8s or docker)

```bash
curl -fsSL https://raw.githubusercontent.com/rajamummidi9/network-multitool/main/scripts/debug.sh | bash
```

---

## Apply debug pod (stays running — share with team)

```bash
kubectl apply -f https://raw.githubusercontent.com/rajamummidi9/network-multitool/main/kubernetes/debug-pod.yaml
kubectl exec -it network-multitool-debug -- bash
```

Delete when done:

```bash
kubectl delete pod network-multitool-debug
```

---

## Test something from inside the pod

```bash
dig +short kubernetes.default.svc.cluster.local
ping -c 3 8.8.8.8
curl -v http://my-service:8080/health
nc -zv my-service 443
tcpdump -i any -c 10 port 443
```

---

## Image tags

| Pull command | When to use |
|--------------|-------------|
| `rajamummidi9/network-multitool` | Default — most incidents |
| `rajamummidi9/network-multitool:extra` | Need socat, nc, iperf3 |
| `rajamummidi9/network-multitool:openshift` | OpenShift / restricted clusters |

**Works on:** AWS EKS, Azure AKS, Google GKE, Kind, Minikube, Rancher, OpenShift  
**Architectures:** `amd64` (Intel/AMD servers) + `arm64` (Apple Silicon, Graviton)

---

## Links

- GitHub: https://github.com/rajamummidi9/network-multitool
- Docker Hub: https://hub.docker.com/r/rajamummidi9/network-multitool
