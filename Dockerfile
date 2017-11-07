FROM alpine:3.6

LABEL maintainer="Ruzhentsev Alexandr <git@pgallery.ru>"
LABEL version="1.0 beta"
LABEL description="Docker image mysql-backup"

COPY scripts/ /usr/local/bin/

RUN apk add --no-cache bash sshpass mysql-client python3 curl tzdata gzip \
    && curl -s https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py \
    && python3 /tmp/get-pip.py \
    && pip3 install awscli

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh \
    && chmod 755 /usr/local/bin/backup-now.sh

COPY config/	/root/.aws/

VOLUME /root/.aws
VOLUME /backup
VOLUME /var/www/html

CMD ["/usr/local/bin/docker-entrypoint.sh"]
