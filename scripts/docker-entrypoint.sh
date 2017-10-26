#!/bin/bash

if [[ -n "$DEBUG" ]]; then
  set -x
fi

if [ -f /var/www/html/gallery/.env ];then

    source /var/www/html/gallery/.env
    TIMEZONE=${APP_TIMEZONE}

else

    DB_HOST=${DB_HOST:-127.0.0.1}
    DB_PORT=${DB_HOST:-3306}
    DB_USERNAME=${DB_USERТФЬУ:-root}
    TIMEZONE=${TIMEZONE:-Europe/Moscow}

fi

DUMP_INTERVAL=${DUMP_INTERVAL:-1440}
DUMP_BEGIN=${DUMP_BEGIN:-15}
DUMP_PREFIX=${DUMP_PREFIX:-db_}

# set timezone
ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

sleep $((DUMP_BEGIN*60))

while true; do
    backup_date=`date +"%G-%m-%d_%H_%M_%S"`
    backup_file=/backup/${DUMP_PREFIX}${backup_date}.sql.gz

    mysqldump -h${DB_HOST} -P${DB_PORT} -u${DB_USERNAME} -p${DB_PASSWORD} --no-create-db --databases ${DB_DATABASE} | gzip > $backup_file

    if [[ ! -z ${BACKUP_USER} && ! -z ${BACKUP_PASSWORD} && ! -z ${BACKUP_HOST} && ! -z ${BACKUP_DIR} ]]; then
	sshpass -p "${BACKUP_PASSWORD}" scp  -o "StrictHostKeyChecking no" ${backup_file} ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_DIR}
	rm -f ${backup_file}
    fi

    sleep $(($DUMP_INTERVAL*60))
done
