# docker-atlassian-bitbucket

This is a Docker-Image for Atlassian Bitbucket based on [Alpine Linux](http://alpinelinux.org/), which is kept as small as possible.

## Features

* Small image size
* Setting application context path
* Setting JVM xms and xmx values
* Setting proxy parameters in server.xml to run it behind a reverse proxy (TOMCAT_PROXY_* ENV)

## Variables

* TOMCAT_CONTEXT_PATH: default context path for bitbucket is "/"

Using with HTTP reverse proxy, not necessary with AJP:

* TOMCAT_PROXY_NAME: domain of bitbucket instance
* TOMCAT_PROXY_PORT: e.g. 443
* TOMCAT_PROXY_SCHEME: e.g. "https"

JVM memory management:

* JVM_MEMORY_MIN
* JVM_MEMORY_MAX

Crowd:

* To enable SSO change 'plugin.auth-crowd.sso.enabled' in 'BITBUCKET_HOME/shared/bitbucket.properties' to 'true'.
* The file is being created by the setup process, it may not exist directly after startup.
Ref.: [Bitbucket Docs](https://confluence.atlassian.com/bitbucketserver/connecting-bitbucket-server-to-crowd-776640399.html#ConnectingBitbucketServertoCrowd-Singlesign-on(SSO)withCrowd)

## Ports
* 7990
* 7999

## Build container
Specify the application version in the build command:

```bash
docker build --build-arg VERSION=x.x.x .                                                        
```

## Getting started

Run Bitbucket standalone and navigate to `http://[dockerhost]:7990` to finish configuration:

```bash
docker run -tid -p 7990:7990 -p 7999:7999 seibertmedia/atlassian-bitbucket:latest
```

Run Bitbucket standalone with customised jvm settings and navigate to `http://[dockerhost]:7990` to finish configuration:

```bash
docker run -tid -p 7990:7990 -p 7999:7999 -e JVM_MEMORY_MIN=2g -e JVM_MEMORY_MAX=4g seibertmedia/atlassian-bitbucket:latest
```

Specify persistent volume for Bitbucket data directory:

```bash
docker run -tid -p 7990:7990 -p 7999:7999 -v bitbucket_data:/var/opt/atlassian/application-data/bitbucket seibertmedia/atlassian-bitbucket:latest
```

Run Bitbucket behind a reverse (SSL) proxy and navigate to `https://scm.yourdomain.com`:

```bash
docker run -d -e TOMCAT_PROXY_NAME=scm.yourdomain.com -e TOMCAT_PROXY_PORT=443 -e TOMCAT_PROXY_SCHEME=https seibertmedia/atlassian-bitbucket:latest
```

Run Bitbucket behind a reverse (SSL) proxy with customised jvm settings and navigate to `https://scm.yourdomain.com`:

```bash
docker run -d -e TOMCAT_PROXY_NAME=scm.yourdomain.com -e TOMCAT_PROXY_PORT=443 -e TOMCAT_PROXY_SCHEME=https -e JVM_MEMORY_MIN=2g -e JVM_MEMORY_MAX=4g seibertmedia/atlassian-bitbucket:latest
```
