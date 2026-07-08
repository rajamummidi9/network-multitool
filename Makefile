.PHONY: build push release tools test k8s-debug k8s-deploy

IMAGE ?= rajamummidi9/network-multitool
TAG   ?= latest

build:
	docker build -t $(IMAGE):$(TAG) .

push: build
	docker push $(IMAGE):$(TAG)

release:
	./scripts/build-and-push.sh $(TAG)

tools:
	docker run --rm $(IMAGE):$(TAG) /docker/tools-check.sh 2>/dev/null || \
	docker run --rm $(IMAGE):$(TAG) /bin/bash /docker/tools-check.sh

test:
	docker run --rm $(IMAGE):$(TAG) /bin/bash -c 'ping -c1 1.1.1.1 && curl -fsS http://127.0.0.1/'

k8s-debug:
	kubectl apply -f kubernetes/debug-pod.yaml

k8s-deploy:
	kubectl apply -f kubernetes/deployment.yaml -f kubernetes/service.yaml

shell:
	docker run --rm -it $(IMAGE):$(TAG) /bin/bash
