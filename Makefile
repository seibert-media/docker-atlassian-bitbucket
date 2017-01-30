VERSION ?= 4.12.1
REGISTRY ?= docker.seibert-media.net

default: build

all: build upload clean

clean:
	docker rmi $(REGISTRY)/seibertmedia/atlassian-bitbucket:$(VERSION)

build:
	docker build --no-cache --rm=true --build-arg VERSION=$(VERSION) -t $(REGISTRY)/seibertmedia/atlassian-bitbucket:$(VERSION) .

upload:
	docker push $(REGISTRY)/seibertmedia/atlassian-bitbucket:$(VERSION)
