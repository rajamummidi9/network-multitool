.PHONY: build build-minimal build-extra build-openshift push release tools test shell

IMAGE ?= rajamummidi9/network-multitool

build-minimal:
	docker build -f Dockerfile -t $(IMAGE):minimal -t $(IMAGE):latest .

build-extra:
	docker build -f Dockerfile.extra -t $(IMAGE):extra .

build-openshift:
	docker build -f Dockerfile.openshift -t $(IMAGE):openshift .

build: build-minimal build-extra build-openshift

push:
	./scripts/build-and-push.sh all latest

release:
	./scripts/build-and-push.sh all $(TAG)

tools:
	docker run --rm $(IMAGE):extra /docker/tools-check.sh

test:
	docker run --rm $(IMAGE):minimal /bin/bash -c 'ping -c1 1.1.1.1 && curl -fsS http://127.0.0.1/'

shell:
	docker run --rm -it $(IMAGE):extra /bin/bash

k8s-debug:
	kubectl apply -f kubernetes/debug-pod.yaml

k8s-deploy:
	kubectl apply -k kubernetes/
