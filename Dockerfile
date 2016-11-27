##############################################################################
# Dockerfile to build Atlassian Bitbucket container images
# Based on anapsix/alpine-java:8_server-jre
##############################################################################

FROM anapsix/alpine-java:8_server-jre

MAINTAINER //SEIBERT/MEDIA GmbH <docker@seibert-media.net>

ARG VERSION

ENV BITBUCKET_INST /opt/atlassian/bitbucket
ENV BITBUCKET_HOME /var/opt/atlassian/application-data/bitbucket

RUN set -x \
  && apk add git tar xmlstarlet --update-cache --allow-untrusted --repository http://dl-cdn.alpinelinux.org/alpine/edge/main --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && mkdir -p $BITBUCKET_INST \
  && mkdir -p $BITBUCKET_HOME

ADD https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-$VERSION.tar.gz /tmp

RUN set -x \
  && tar xvfz /tmp/atlassian-bitbucket-$VERSION.tar.gz --strip-components=1 -C $BITBUCKET_INST \
  && rm /tmp/atlassian-bitbucket-$VERSION.tar.gz

RUN set -x \
  && touch -d "@0" "$BITBUCKET_INST/conf/server.xml" \
  && touch -d "@0" "$BITBUCKET_INST/bin/setenv.sh" \
  && touch -d "@0" "$BITBUCKET_INST/bin/set-bitbucket-home.sh"

ADD files/entrypoint /usr/local/bin/entrypoint

RUN set -x \
  && chown -R daemon:daemon /usr/local/bin/entrypoint \
  && chown -R daemon:daemon $BITBUCKET_INST \
  && chown -R daemon:daemon $BITBUCKET_HOME

EXPOSE 7990
EXPOSE 7999

USER daemon

ENTRYPOINT  ["/usr/local/bin/entrypoint"]
