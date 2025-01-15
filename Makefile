IMAGE := telosalliance/ubuntu-20.04
TAG   ?= $(shell date +%Y-%m-%d)

.PHONY: all image lint run push

all: image

image:
	DOCKER_BUILDKIT=1 docker build $(ARGS) -t $(IMAGE):$(TAG) .
	DOCKER_BUILDKIT=1 docker build $(ARGS) -t $(IMAGE):latest .

push:
	docker image push $(IMAGE):$(TAG)
	docker image push $(IMAGE):latest

lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

run:
	docker run $(ARGS) \
		--hostname $(IMAGE) \
		--env LINUX_USER=$(shell id -un) \
		--env LINUX_UID=$(shell id -u) \
		--env LINUX_GROUP=$(shell id -gn) \
		--env LINUX_GID=$(shell id -g) \
		--mount src=$(HOME),target=$(HOME),type=bind \
		-ti --rm $(IMAGE):$(TAG)
