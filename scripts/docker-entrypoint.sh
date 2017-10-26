#!/bin/bash

if [[ -n "$DEBUG" ]]; then
  set -x
fi

DUMP_INTERVAL=${DUMP_INTERVAL:-1440}
DUMP_BEGIN=${DUMP_BEGIN:-15}
DUMP_PREFIX=${DUMP_PREFIX:-db_}
DB_HOST=${DB_HOST:-127.0.0.1}
DB_USER=${DB_USER:-root}
TIMEZONE=${TIMEZONE:-Europe/Moscow}

# set timezone
ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

sleep $((DUMP_BEGIN*60))

while true; do
    backup_date=`date +"%G-%m-%d_%H_%M_%S"`
    backup_file=/backup/${DUMP_PREFIX}${backup_date}.sql.gz

    mysqldump -A -h $DB_HOST -u$DB_USER -p$DB_PASSWORD | gzip > $backup_file

    if [[ ! -z $BACKUP_USER && ! -z $BACKUP_PASSWORD && ! -z $BACKUP_HOST && ! -z $BACKUP_DIR ]]; then
	sshpass -p "$BACKUP_PASSWORD" scp  -o "StrictHostKeyChecking no" $backup_file $BACKUP_USER@$BACKUP_HOST:$BACKUP_DIR
	rm -f $backup_file
    fi

    sleep $(($DUMP_INTERVAL*60))
done
