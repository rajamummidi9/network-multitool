# Create Docker Hub organization: `netkit`

## Step 1 — Create the org (browser)

The Docker Hub org creation page should be open. If not:

**https://app.docker.com/accounts/create-organization**

Fill in:

| Field | Value |
|-------|-------|
| **Organization namespace** | `netkit` |
| **Company name** | `NetKit` (or your preference) |
| **Plan** | Free / Team — Free works for public repos |

> Namespace cannot be changed later. `netkit` is currently **available** (404 on Docker Hub).

## Step 2 — Create the repository

After the org exists, create a public repo:

**https://hub.docker.com/orgs/netkit/repositories/create**

| Field | Value |
|-------|-------|
| Repository name | `network-multitool` |
| Visibility | **Public** |
| Description | `Multi-arch Kubernetes network debug container` |

## Step 3 — Push images

Run from the project root (requires `docker login`):

```bash
./scripts/migrate-to-netkit.sh
```

This retags and pushes all variants to `netkit/network-multitool`:

| Tag | Image |
|-----|-------|
| `latest`, `minimal` | `netkit/network-multitool:latest` |
| `extra` | `netkit/network-multitool:extra` |
| `openshift` | `netkit/network-multitool:openshift` |

## Step 4 — Verify

```bash
docker pull netkit/network-multitool
docker manifest inspect netkit/network-multitool:latest | grep architecture
```

## New global command (after migration)

```bash
kubectl run netkit --rm -it --restart=Never \
  --image=netkit/network-multitool \
  --image-pull-policy=Always -- bash
```

## Keep both names?

You can keep `rajamummidi9/network-multitool` as a mirror and use `netkit/network-multitool` as the public brand. The migration script pushes to both if you pass `--keep-old`.
