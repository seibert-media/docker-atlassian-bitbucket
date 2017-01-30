ATLASSIAN_VERSION ?= $(VERSION)
REGISTRY ?= docker.seibert-media.net

default: build

all: build upload clean

clean: checkvars
	docker rmi $(REGISTRY)/seibertmedia/atlassian-bitbucket:$(VERSION)

build: checkvars
	docker build --no-cache --rm=true --build-arg VERSION=$(ATLASSIAN_VERSION) -t $(REGISTRY)/seibertmedia/atlassian-bitbucket:$(VERSION) .

upload: checkvars
	docker push $(REGISTRY)/seibertmedia/atlassian-bitbucket:$(VERSION)

checkvars:
ifndef VERSION
	$(error env variable VERSION has to be set)
endif