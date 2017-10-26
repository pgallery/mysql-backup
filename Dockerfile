FROM debian:stretch

LABEL maintainer="Ruzhentsev Alexandr <git@pgallery.ru>"
LABEL version="1.0 beta"
LABEL description="Docker image mysql-backup"

COPY scripts/ /usr/local/bin/

RUN apt-get update && apt-get -y upgrade && apt-get install -y sshpass mysql-client \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && chmod 755 /usr/local/bin/docker-entrypoint.sh

VOLUME /backup

CMD ["/usr/local/bin/docker-entrypoint.sh"]
