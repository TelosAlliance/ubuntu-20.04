IMAGE := telosalliance/ubuntu-18.04
TAG   ?= latest

.PHONY: all image run

all: image

image:
	docker build $(ARGS) -t $(IMAGE):$(TAG) .

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
		-ti $(IMAGE):$(TAG)
