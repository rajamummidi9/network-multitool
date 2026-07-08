# Apply all Kubernetes resources
kubectl apply -f deployment.yaml -f service.yaml

# Or deploy as DaemonSet on every node (hostNetwork, custom ports 1180/11443)
# kubectl apply -f daemonset.yaml

# Or spin up a one-off debug pod
# kubectl apply -f debug-pod.yaml
# kubectl exec -it network-multitool-debug -- /bin/bash
