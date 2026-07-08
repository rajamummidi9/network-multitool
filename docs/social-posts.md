# Sharing content

Ready-to-paste copy for LinkedIn, colleagues, and other channels.

---

## LinkedIn post (main)

> 🚀 I published my own Kubernetes network debugging container: `rajamummidi9/network-multitool`
>
> Every DevOps engineer has hit this: you exec into a pod during an incident and there's no curl, no dig, no ping — nothing to actually debug with.
>
> So I built (and open-sourced) a purpose-built troubleshooting image:
>
> 3 variants:
> • minimal (~117 MB) — curl, dig, ping, mtr, tcpdump, traceroute, nginx
> • extra (~120 MB) — + socat, nc, iperf3, ethtool, lsof
> • openshift — non-root, works on locked-down SCCs
>
> ✅ Multi-arch: linux/amd64 + linux/arm64
> ✅ Automated multi-arch builds via GitHub Actions
> ✅ Ready-made Kubernetes Deployment, Service, DaemonSet & debug-pod manifests
>
> One command to drop a fully-loaded debug pod into any cluster:
>
> kubectl run multitool --image=rajamummidi9/network-multitool -it -- bash
>
> 🐳 Docker Hub: https://hub.docker.com/r/rajamummidi9/network-multitool
> 💻 GitHub: https://github.com/rajamummidi9/network-multitool
>
> Feedback and PRs welcome! What tool do you always wish was in your debug container?
>
> #Kubernetes #DevOps #Docker #SRE #CloudNative #Containers #OpenShift #Platform Engineering

---

## LinkedIn post (short version)

> Tired of exec-ing into a pod with no curl, no dig, no ping? 😩
>
> I open-sourced a multi-arch network debugging container for Kubernetes:
>
> kubectl run multitool --image=rajamummidi9/network-multitool -it -- bash
>
> curl, dig, tcpdump, mtr, nc, iperf3, socat + more. amd64 & arm64.
>
> 🐳 https://hub.docker.com/r/rajamummidi9/network-multitool
> 💻 https://github.com/rajamummidi9/network-multitool
>
> #Kubernetes #DevOps #Docker #SRE #CloudNative

---

## Message to colleagues (Slack / Teams)

> Hey team 👋 — I put together a network debugging container we can use across our clusters.
>
> Instead of struggling to debug from app pods that have no tools, just run:
>
> `kubectl run multitool --image=rajamummidi9/network-multitool -it -- bash`
>
> It has curl, dig, ping, tcpdump, mtr, nc, iperf3, socat, openssl, etc. There's also a DaemonSet manifest for node-level network debugging (no SSH needed).
>
> Variants: `:latest` (minimal), `:extra` (more tools), `:openshift` (non-root).
>
> Repo with manifests + docs: https://github.com/rajamummidi9/network-multitool
>
> Let me know if there's a tool you'd like added.

---

## X / Twitter thread

**1/**
> Built & open-sourced a Kubernetes network debugging container 🧰🐳
>
> No more exec-ing into pods with zero tools during an incident.
>
> kubectl run multitool --image=rajamummidi9/network-multitool -it -- bash

**2/**
> 3 variants:
> • minimal ~117MB
> • extra ~120MB (socat, nc, iperf3…)
> • openshift (non-root)
>
> Multi-arch: amd64 + arm64. Auto-built via GitHub Actions.

**3/**
> Comes with ready-made K8s manifests: Deployment, Service, DaemonSet (node debugging, no SSH), and a debug pod.
>
> 💻 https://github.com/rajamummidi9/network-multitool
> 🐳 https://hub.docker.com/r/rajamummidi9/network-multitool

---

## Posting tips

- **Best time to post on LinkedIn:** Tuesday–Thursday, 8–10 AM your audience's time.
- **Attach the explainer image** (`docs/network-multitool-explainer.png`) — posts with a visual get 2× the engagement.
- **First comment:** drop the GitHub link again (LinkedIn slightly downranks posts with outbound links in the body, so putting the link in the first comment helps reach).
- **Reply to every comment** in the first hour — it boosts distribution.
- **Cross-post** the blog to dev.to, Medium, and Hashnode with a canonical link back to your GitHub or personal site.
- **Tag** relevant communities/hashtags but keep it under ~5 hashtags for LinkedIn.
