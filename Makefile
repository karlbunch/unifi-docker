.PHONY: usage build build-nocache push nightly test

# http://dl.ubnt.com/unifi/5.7.20/unifi_sysvinit_all.deb
VERSION=5.7.20
REPO=karlbunch/unifi
TAG=$(VERSION)-001
BUILDARGS=--build-arg VERSION=$(VERSION)

usage:
	@echo "build - Build image"
	@echo "build-nocache - Build image w/o using cache"
	@echo "test - Run the image locally"
	@echo "clean - cleanup test images"

build:
	docker build --squash $(BUILDARGS) -t $(REPO):$(TAG) .

build-nocache: lint
	-docker image rm $(REPO):$(TAG)
	docker build --squash --no-cache $(BUILDARGS) -t $(REPO):$(TAG) .

push:
	#docker push $(REPO):$(TAG)

nightly: clean build-nocache push

run:
	docker run -d --rm --init --net=host -p 8080:8080 -p 8443:8443 -p 3478:3478/udp -p 10001:10001/udp -v unifi:/unifi --name unifi $(REPO):$(TAG)
