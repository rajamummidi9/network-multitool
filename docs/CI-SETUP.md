# CI/CD setup for multi-arch Docker Hub publishes

Add these **GitHub repository secrets** at:
https://github.com/rajamummidi9/network-multitool/settings/secrets/actions

| Secret | Value |
|--------|-------|
| `DOCKERHUB_USERNAME` | `rajamummidi9` |
| `DOCKERHUB_TOKEN` | Docker Hub → Account Settings → Security → New Access Token |

## Set secrets via GitHub CLI

```bash
gh secret set DOCKERHUB_USERNAME -b "rajamummidi9" -R rajamummidi9/network-multitool
gh secret set DOCKERHUB_TOKEN -b "<your-docker-hub-token>" -R rajamummidi9/network-multitool
```

## Trigger a build manually

```bash
gh workflow run build-push.yml -R rajamummidi9/network-multitool
```

## Published tags (on push to `main`)

| Tag | Variant | Platforms |
|-----|---------|-----------|
| `latest`, `minimal` | Core tools (~40 MB) | `amd64`, `arm64` |
| `extra` | Full toolkit (~120 MB) | `amd64`, `arm64` |
| `openshift` | Non-root, ports 1180/11443 | `amd64`, `arm64` |
