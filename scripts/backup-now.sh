#!/bin/bash

if [[ -n "$DEBUG" ]]; then
  set -x
fi

if [ -f /var/www/html/gallery/.env ];then

    source /var/www/html/gallery/.env

else

    DB_HOST=${DB_HOST:-127.0.0.1}
    DB_PORT=${DB_HOST:-3306}
    DB_USERNAME=${DB_USERNAME:-root}

fi

DUMP_PREFIX=${DUMP_PREFIX:-db_}
DUMP_STORAGE=${DUMP_STORAGE:-local}

    backup_date=`date +"%G-%m-%d_%H_%M_%S"`
    backup_file=/backup/${DUMP_PREFIX}${backup_date}.sql.gz

    mysqldump -h${DB_HOST} -P${DB_PORT} -u${DB_USERNAME} -p${DB_PASSWORD} --no-create-db --databases ${DB_DATABASE} | gzip > $backup_file

    if [[ ! -z ${BACKUP_USER} && ! -z ${BACKUP_PASSWORD} && ! -z ${BACKUP_HOST} && ! -z ${BACKUP_DIR} ]]; then

	sshpass -p "${BACKUP_PASSWORD}" scp  -o "StrictHostKeyChecking no" ${backup_file} ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_DIR}
	rm -f ${backup_file}

    fi

    if [ ${DUMP_STORAGE} == 'aws' ]; then

	aws --endpoint-url=https://${BACKUP_AWS_ENDPOINT}/ s3 cp $backup_file s3://${BACKUP_AWS_BUCKET}/
	rm -f ${backup_file}

    fi
