##############################################################################
# Dockerfile to build Atlassian Bitbucket container images
# Based on anapsix/alpine-java:8_server-jre
##############################################################################

FROM anapsix/alpine-java:8_server-jre

MAINTAINER //SEIBERT/MEDIA GmbH <docker@seibert-media.net>

ARG VERSION

ENV BITBUCKET_INST /opt/bitbucket
ENV BITBUCKET_HOME /var/opt/bitbucket
ENV SYSTEM_USER bitbucket
ENV SYSTEM_GROUP bitbucket
ENV SYSTEM_HOME /home/bitbucket

RUN set -x \
  && apk add git=2.8.3-r0 su-exec tar perl xmlstarlet wget ca-certificates openssh --update-cache --allow-untrusted --repository http://dl-cdn.alpinelinux.org/alpine/edge/main --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && mkdir -p ${BITBUCKET_INST} \
  && mkdir -p ${BITBUCKET_HOME}

RUN set -x \
  && mkdir -p ${SYSTEM_HOME} \
  && addgroup -S ${SYSTEM_GROUP} \
  && adduser -S -D -G ${SYSTEM_GROUP} -h ${SYSTEM_HOME} -s /bin/sh ${SYSTEM_USER} \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${SYSTEM_HOME}

RUN set -x \
  && wget -nv -O /tmp/atlassian-bitbucket-${VERSION}.tar.gz https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${VERSION}.tar.gz \
  && tar xfz /tmp/atlassian-bitbucket-${VERSION}.tar.gz --strip-components=1 -C ${BITBUCKET_INST} \
  && rm /tmp/atlassian-bitbucket-${VERSION}.tar.gz \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${BITBUCKET_INST} \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${BITBUCKET_HOME}

RUN set -x \
  && touch -d "@0" "${BITBUCKET_INST}/conf/server.xml" \
  && touch -d "@0" "${BITBUCKET_INST}/bin/setenv.sh" \
  && touch -d "@0" "${BITBUCKET_INST}/bin/set-bitbucket-home.sh"

ADD files/service /usr/local/bin/service
ADD files/entrypoint /usr/local/bin/entrypoint

EXPOSE 7990 7999 8009

VOLUME ${BITBUCKET_HOME}

ENTRYPOINT ["/usr/local/bin/entrypoint"]

CMD ["/usr/local/bin/service"]
