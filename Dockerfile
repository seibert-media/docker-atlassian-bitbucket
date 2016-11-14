##############################################################################
# Dockerfile to build Atlassian Bitbucket container images
# Based on anapsix/alpine-java:8_server-jre
##############################################################################

FROM anapsix/alpine-java:8_server-jre

MAINTAINER //SEIBERT/MEDIA GmbH <docker@seibert-media.net>

ENV VERSION 0.0.0

RUN set -x \
  && apk add git tar xmlstarlet --update-cache --allow-untrusted --repository http://dl-cdn.alpinelinux.org/alpine/edge/main --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && mkdir -p /opt/atlassian/bitbucket \
  && mkdir -p /var/opt/atlassian/application-data/bitbucket

ADD https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-$VERSION.tar.gz /tmp

RUN set -x \
  && tar xvfz /tmp/atlassian-bitbucket-$VERSION.tar.gz --strip-components=1 -C /opt/atlassian/bitbucket \
  && rm /tmp/atlassian-bitbucket-$VERSION.tar.gz

RUN set -x \
  && sed --in-place 's/export BITBUCKET_HOME=/export BITBUCKET_HOME=\/var\/opt\/atlassian\/application-data\/bitbucket/' /opt/atlassian/bitbucket/bin/set-bitbucket-home.sh

RUN set -x \
  && touch -d "@0" "/opt/atlassian/bitbucket/conf/server.xml" \
  && touch -d "@0" "/opt/atlassian/bitbucket/bin/setenv.sh"

ADD files/entrypoint /usr/local/bin/entrypoint
ADD files/_.codeyard.com.crt /tmp/_codeyard.com.crt

RUN set -x \
  && /opt/jdk/bin/keytool -import -trustcacerts -noprompt -keystore /opt/jdk/jre/lib/security/cacerts -storepass changeit -alias CODEYARD -file /tmp/_codeyard.com.crt

RUN set -x \
  && chown -R daemon:daemon /usr/local/bin/entrypoint \
  && chown -R daemon:daemon /opt/atlassian/bitbucket \
  && chown -R daemon:daemon /var/opt/atlassian/application-data/bitbucket

EXPOSE 7990
EXPOSE 7999

USER daemon

ENTRYPOINT  ["/usr/local/bin/entrypoint"]
