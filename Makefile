VERSION ?= 4.12.1
MYSQL_JDBC_VERSION ?= 5.1.40
REGISTRY ?= docker.seibert-media.net

default: build

all: build upload clean

clean:
	docker rmi $(REGISTRY)/seibertmedia/atlassian-bitbucket:$(VERSION)

build:
	docker build --no-cache --rm=true --build-arg VERSION=$(VERSION) --build-arg MYSQL_JDBC_VERSION=$(MYSQL_JDBC_VERSION) -t $(REGISTRY)/seibertmedia/atlassian-bitbucket:$(VERSION) .

upload:
	docker push $(REGISTRY)/seibertmedia/atlassian-bitbucket:$(VERSION)
