FROM openjdk:8-jre-stretch

RUN apt-get update && apt-get install procps -y

ENV SOLR_USER="solr" \
    SOLR_UID="8983" \
    SOLR_GROUP="solr" \
    SOLR_GID="8983" \
    PATH="/opt/solr/bin:/opt/docker-solr/scripts:$PATH"

ARG SOLR_ARG_VERSION

ENV SOLR_VERSION=$SOLR_ARG_VERSION

RUN set -e; \
  groupadd -r --gid "$SOLR_GID" "$SOLR_GROUP"; \
  useradd -r --uid "$SOLR_UID" --gid "$SOLR_GID" "$SOLR_USER"

COPY package/solr-${SOLR_VERSION}.tgz /opt/solr-${SOLR_VERSION}.tgz

RUN tar -C /opt -zxvf /opt/solr-${SOLR_VERSION}.tgz; \
  mv "/opt/solr-$SOLR_VERSION" /opt/solr; \
  rm -Rf /opt/solr/docs/; \
  rm -Rf /opt/solr-${SOLR_VERSION}.tgz; \
  chmod -R 0755 /opt/solr/server/scripts/cloud-scripts; \
  chown -R "$SOLR_USER:$SOLR_GROUP" /opt/solr;

WORKDIR /opt/solr

USER $SOLR_USER

ADD script/start.sh /opt/solr/

EXPOSE 8983

CMD ["/opt/solr/start.sh"]
