# docker-atlassian-bitbucket

This is a Docker-Image for Atlassian Bitbucket based on [Alpine Linux](http://alpinelinux.org/), which is kept as small as possible.

## Features

* Small image size
* Setting application context path
* Setting JVM xms and xmx values
* Setting proxy parameters in server.xml to run it behind a reverse proxy (TOMCAT_PROXY_* ENV)

## Variables

* TOMCAT_PROXY_NAME
* TOMCAT_PROXY_PORT
* TOMCAT_PROXY_SCHEME
* TOMCAT_CONTEXT_PATH
* JVM_MEMORY_MIN
* JVM_MEMORY_MAX

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
